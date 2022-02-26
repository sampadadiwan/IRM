# == Schema Information
#
# Table name: investments
#
#  id                    :integer          not null, primary key
#  investment_type       :string(20)
#  investor_id           :integer
#  investor_type         :string(20)
#  investee_entity_id    :integer
#  status                :string(20)
#  investment_instrument :string(50)
#  quantity              :integer
#  initial_value         :decimal(20, )
#  current_value         :decimal(20, )
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  category              :string(25)
#  deleted_at            :datetime
#  percentage_holding    :decimal(5, 2)
#

class Investment < ApplicationRecord
  include Trackable

  encrypts :investment_instrument, deterministic: true
  encrypts :investment_type, :category

  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  belongs_to :investor
  delegate :investor_entity_id, to: :investor
  belongs_to :investee_entity, class_name: "Entity"

  counter_culture :investee_entity
  counter_culture :investee_entity, column_name: 'total_investments', delta_column: 'initial_value'

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

  before_create :update_employee_holdings
  def update_employee_holdings
    self.employee_holdings = true if investment_type == "Employee Holdings"
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
    end
  end

  # after_save :update_percentage_holdings
  def update_percentage_holdings
    entity_investments = Investment.where(investee_entity_id: investee_entity_id)
    total_quantity = entity_investments.reject { |i| i.investment_instrument == "Debt" }.inject(0) { |result, i| result + i.quantity }

    entity_investments.each do |inv|
      if inv.investment_instrument != "Debt"
        inv.percentage_holding = (inv.quantity * 100.0) / total_quantity
        inv.save
      end
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
