# == Schema Information
#
# Table name: investments
#
#  id                      :integer          not null, primary key
#  investment_type         :string(100)
#  investor_id             :integer
#  investor_type           :string(100)
#  investee_entity_id      :integer
#  status                  :string(20)
#  investment_instrument   :string(100)
#  quantity                :integer          default("0")
#  initial_value           :decimal(20, 2)   default("0.00")
#  current_value           :decimal(20, 2)   default("0.00")
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  category                :string(100)
#  deleted_at              :datetime
#  percentage_holding      :decimal(5, 2)    default("0.00")
#  employee_holdings       :boolean          default("0")
#  diluted_quantity        :integer          default("0")
#  diluted_percentage      :decimal(5, 2)    default("0.00")
#  currency                :string(10)
#  units                   :string(15)
#  amount_cents            :decimal(20, 2)   default("0.00")
#  price_cents             :decimal(20, 2)
#  funding_round_id        :integer
#  liquidation_preference  :decimal(4, 2)
#  scenario_id             :integer          not null
#  aggregate_investment_id :integer
#

class Investment < ApplicationRecord
  include Trackable
  include InvestmentScopes
  include InvestmentCounters
  # Make all models searchable
  update_index('investment') { self }

  validates :quantity, :price, presence: true
  # "Equity,Preferred,Debt,ESOPs"
  INSTRUMENT_TYPES = ENV["INSTRUMENT_TYPES"].split(",")

  # "Lead Investor,Co-Investor,Founder,Individual,Employee"
  INVESTOR_CATEGORIES = ENV["INVESTOR_CATEGORIES"].split(",")

  # encrypts :investment_type
  has_rich_text :notes

  # Investments which belong to the Actual scenario are the real ones
  # All others are imaginary scenarios for planning and dont add to the real
  belongs_to :scenario

  belongs_to :investor
  delegate :investor_entity_id, to: :investor
  delegate :investor_name, to: :investor

  belongs_to :funding_round
  delegate :name, to: :funding_round, prefix: :funding_round

  belongs_to :aggregate_investment, optional: true

  belongs_to :investee_entity, class_name: "Entity"
  delegate :actual_scenario, to: :investee_entity
  delegate :name, to: :investee_entity, prefix: :investee

  has_many :holdings, dependent: :destroy

  # Handled by money-rails gem
  monetize :amount_cents, :price_cents, with_model_currency: :currency

  def self.INVESTOR_CATEGORIES(entity = nil)
    entity && entity.investor_categories.present? ? entity.investor_categories.split(",").map(&:strip) : INVESTOR_CATEGORIES
  end

  def self.INSTRUMENT_TYPES(entity = nil)
    entity && entity.instrument_types.present? ? entity.instrument_types.split(",").map(&:strip) : INSTRUMENT_TYPES
  end

  def to_s
    investor.investor_name
  end

  before_save :update_defaults
  before_save :update_aggregate_investment,
              if: proc { |i| EQUITY_LIKE.include? i.investment_instrument }

  def update_defaults
    if investor.is_holdings_entity
      # This is because each holding has a quantity, price and a value
      # The quantity and value is added to the investment
      # So we compute the avg price
      self.price = amount / quantity if quantity.positive?
    else
      self.amount = quantity * price
    end
    self.currency = investee_entity.currency
    self.units = investee_entity.units
    self.investment_type = funding_round.name
    self.investment_instrument = investment_instrument.strip
    self.employee_holdings = true if investment_type == "Employee Holdings"
  end

  def update_aggregate_investment
    ai = AggregateInvestment.where(investor_id: investor_id,
                                   entity_id: investee_entity_id,
                                   scenario_id: scenario_id).first
    self.aggregate_investment = ai.presence || AggregateInvestment.create(investor_id: investor_id,
                                                                          entity_id: investee_entity_id,
                                                                          scenario_id: scenario_id)
  end

  after_save :update_investor_holdings, if: proc { |i| i.scenario.actual? }
  # For Actual Scenario, for Investors (Not Employees or Founders), we want to create a holding
  # corresponding to this investment.
  # There will be only one such Holding per investment
  def update_investor_holdings
    if EQUITY_LIKE.include?(investment_instrument) && !investor.is_holdings_entity
      holding = holdings.first
      if holding
        # Since there is only 1 holding per Investor Investment
        # Just assign the quantityand price
        holding.quantity = quantity
        holding.price = price
      else
        holding = holdings.build(entity_id: investee_entity_id, investor_id: investor_id,
                                 funding_round_id: funding_round_id,
                                 holding_type: "Investor",
                                 investment_instrument: investment_instrument,
                                 quantity: quantity, price: price, value: amount)
      end

      holding.save!
    else
      # For Debt and other Non Equity - we dont need a holding
      Rails.logger.debug { "Not creating holdings for #{to_json}" }
    end
  end

  def self.for_investor(current_user, entity)
    actual_scenario = entity.actual_scenario
    investments = actual_scenario.investments
                                 # Ensure the access rights for Investment
                                 .joins(investee_entity: %i[investors access_rights])
                                 .merge(AccessRight.access_filter)
                                 # Ensure that the user is an investor and tis investor has been given access rights
                                 .where("entities.id=?", entity.id)
                                 .where("investors.investor_entity_id=?", current_user.entity_id)
                                 # Ensure this user has investor access
                                 .joins(investee_entity: :investor_accesses)
                                 .merge(InvestorAccess.approved_for_user(current_user))

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
    end

    investments
  end
end
