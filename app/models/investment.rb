# == Schema Information
#
# Table name: investments
#
#  id                    :integer          not null, primary key
#  investment_type       :string(100)
#  investor_id           :integer
#  investor_type         :string(100)
#  investee_entity_id    :integer
#  status                :string(20)
#  investment_instrument :string(100)
#  quantity              :integer          default("0")
#  initial_value         :decimal(20, 2)   default("0.00")
#  current_value         :decimal(20, 2)   default("0.00")
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  category              :string(100)
#  deleted_at            :datetime
#  percentage_holding    :decimal(5, 2)
#  employee_holdings     :boolean          default("0")
#  diluted_quantity      :integer          default("0")
#  diluted_percentage    :decimal(5, 2)    default("0.00")
#  price                 :decimal(10, )    default("0")
#  amount                :decimal(20, 2)   default("0.00")
#  currency              :string(10)
#  units                 :string(15)
#

class Investment < ApplicationRecord
  include Trackable

  encrypts :investment_type, :category

  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  belongs_to :investor
  delegate :investor_entity_id, to: :investor
  belongs_to :investee_entity, class_name: "Entity"

  counter_culture :investee_entity
  counter_culture :investee_entity, column_name: 'total_investments', delta_column: 'initial_value'

  # Handled by money-rails gem
  monetize :amount_cents, :price_cents, with_currency: ->(i) { i.currency }

  # "Series A,Series B,Series C"
  INVESTMENT_TYPES = ENV["INVESTMENT_TYPES"].split(",")

  # "Equity,Preferred,Debt,ESOPs"
  INSTRUMENT_TYPES = ENV["INSTRUMENT_TYPES"].split(",")

  # "Lead Investor,Co-Investor,Founder,Individual,Employee"
  INVESTOR_CATEGORIES = ENV["INVESTOR_CATEGORIES"].split(",")

  scope :prospective, -> { where(investor_type: "Prospective") }
  scope :shareholders, -> { where(investor_type: "Shareholder") }
  scope :debt, -> { where(investment_instrument: "Debt") }
  scope :not_debt, -> { where("investment_instrument <> 'Debt'") }
  scope :equity, -> { where(investment_instrument: "Equity") }
  scope :equity_or_pref, -> { where(investment_instrument: %w[Equity Preferred]) }
  scope :options_or_esop, -> { where(investment_instrument: %w[ESOP Option]) }
  scope :debt, -> { where(investment_instrument: "Debt") }

  # These functions override the defaults based on entities customization
  def self.INVESTMENT_TYPES(entity = nil)
    entity && entity.investment_types.present? ? entity.investment_types.split(",").map(&:strip) : INVESTMENT_TYPES
  end

  def self.INVESTOR_CATEGORIES(entity = nil)
    entity && entity.investor_categories.present? ? entity.investor_categories.split(",").map(&:strip) : INVESTOR_CATEGORIES
  end

  def self.INSTRUMENT_TYPES(entity = nil)
    entity && entity.instrument_types.present? ? entity.instrument_types.split(",").map(&:strip) : INSTRUMENT_TYPES
  end

  def to_s
    investor.investor_name
  end

  before_save :update_amount
  before_create :update_employee_holdings
  def update_employee_holdings
    self.employee_holdings = true if investment_type == "Employee Holdings"
  end

  def update_amount
    self.amount = quantity * price
    self.currency = investee_entity.currency
    self.units = investee_entity.units
  end

  after_destroy :destroy_investor_holdings
  def destroy_investor_holdings
    holding = Holding.where(investor_id: investor_id, investment_instrument: investment_instrument).first
    holding&.destroy
  end

  after_save :update_investor_holdings
  def update_investor_holdings
    if (investment_instrument == "Equity" || investment_instrument == "Preferred") && !investor.is_holdings_entity
      holding = Holding.where(investor_id: investor_id, investment_instrument: investment_instrument).first
      if holding
        holding.quantity = quantity
      else
        holding = Holding.new(entity_id: investee_entity_id, investor_id: investor_id,
                              holding_type: "Investor", investment_instrument: investment_instrument,
                              quantity: quantity)
      end

      holding.save!
    else
      Rails.logger.debug { "Not creating holdings for #{to_json}" }
    end
  end

  # after_save :update_percentage_holdings
  def update_percentage_holdings
    equity_investments = Investment.where(investee_entity_id: investee_entity_id).equity_or_pref
    esop_investments = Investment.where(investee_entity_id: investee_entity_id).options_or_esop
    equity_quantity = equity_investments.sum(:quantity)
    esop_quantity = esop_investments.sum(:quantity)

    equity_investments.each do |inv|
      inv.percentage_holding = (inv.quantity * 100.0) / equity_quantity
      inv.diluted_percentage = (inv.quantity * 100.0) / (equity_quantity + esop_quantity)
      inv.save
    end

    esop_investments.each do |inv|
      inv.percentage_holding = 0
      inv.diluted_percentage = (inv.quantity * 100.0) / (equity_quantity + esop_quantity)
      inv.save
    end
  end

  def self.for_investor(current_user, entity)
    investments = Investment
                  # Ensure the access rights for Investment
                  .joins(investee_entity: %i[investors access_rights])
                  .merge(AccessRight.for_access_type("Investment"))
                  # Ensure that the user is an investor and tis investor has been given access rights
                  .where("entities.id=?", entity.id)
                  .where("investors.investor_entity_id=?", current_user.entity_id)
                  .where("investors.category=access_rights.access_to_category OR access_rights.access_to_investor_id=investors.id")
                  # Ensure this user has investor access
                  .joins(investee_entity: :investor_accesses)
                  .merge(InvestorAccess.approved_for(current_user, entity))

    # return investments if investments.blank?

    # Is this user from an investor
    investor = Investor.for(current_user, entity).first

    # Get the investor access for this user and this entity
    access_right = AccessRight.investments.investor_access(investor).last
    return Investment.none if access_right.nil?

    Rails.logger.debug access_right.to_json

    case access_right.metadata
    when AccessRight::ALL
      # Do nothing - we got all the investments
      logger.debug "Access to investor #{current_user.email} to ALL Entity #{entity.id} investments"
    when AccessRight::SELF
      # Got all the investments for this investor
      logger.debug "Access to investor #{current_user.email} to SELF Entity #{entity.id} investments"
      investments = investments.where(investor_id: investor.id)
    when AccessRight::SUMMARY
      # Show summary page
      logger.debug "Access to investor #{current_user.email} to SUMMARY Entity #{entity.id} investments"
    end

    investments
  end
end
