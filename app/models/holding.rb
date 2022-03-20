# == Schema Information
#
# Table name: holdings
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  entity_id             :integer          not null
#  quantity              :integer          default("0")
#  value_cents           :decimal(20, 2)   default("0.00")
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  investment_instrument :string(100)
#  investor_id           :integer          not null
#  holding_type          :string(15)       not null
#  investment_id         :integer          not null
#  price_cents           :decimal(20, 2)   default("0.00")
#

class Holding < ApplicationRecord
  INVESTMENT_FOR = %w[Employee Founder].freeze

  belongs_to :user, optional: true
  belongs_to :entity
  belongs_to :funding_round
  belongs_to :investor
  has_many :offers, dependent: :destroy

  # Only update the investment if its coming from an employee of a holding company
  before_validation :setup_investment, if: proc { |h| INVESTMENT_FOR.include?(h.holding_type) }
  before_save :update_value

  belongs_to :investment
  has_one :aggregated_investment, through: :investment

  # Add the quantity to the investment
  counter_culture :investment,
                  column_name: proc { |h| INVESTMENT_FOR.include?(h.holding_type) ? 'quantity' : nil },
                  delta_column: 'quantity'

  # Add the quantity to the aggregate_investment, counter culture does not
  # automatically update aggregate_investment even though the investment is updated
  counter_culture %i[investment aggregate_investment],
                  column_name: proc { |h| %w[Equity Preferred Options].include?(h.investment_instrument) ? h.investment_instrument.downcase : nil },
                  delta_column: 'quantity'

  counter_culture :investment,
                  column_name: proc { |h| INVESTMENT_FOR.include?(h.holding_type) ? 'amount_cents' : nil },
                  delta_column: 'value_cents'

  counter_culture %i[investment funding_round],
                  column_name: proc { |h| h.investment.scenario.actual? && INVESTMENT_FOR.include?(h.holding_type) ? 'amount_raised_cents' : nil },
                  delta_column: 'value_cents'

  monetize :price_cents, :value_cents, with_currency: ->(i) { i.entity.currency }

  validates :quantity, :holding_type, presence: true

  after_save ->(_holding) { HoldingUpdateJob.perform_later(id) },
             if: proc { |h| INVESTMENT_FOR.include?(h.holding_type) }

  def update_value
    self.value_cents = quantity * price_cents
  end

  def setup_investment
    self.investment = Investment.for(self).first

    if investment.nil?
      # Rails.logger.debug { "Updating investment for #{to_json}" }
      employee_investor = Investor.for(user, entity).first
      self.investment = Investment.create(investment_type: "#{holding_type} Holdings",
                                          investment_instrument: investment_instrument,
                                          category: holding_type, investee_entity_id: entity.id,
                                          investor_id: employee_investor.id, employee_holdings: true,
                                          quantity: 0, price_cents: price_cents,
                                          currency: entity.currency, funding_round: funding_round,
                                          scenario: entity.actual_scenario, notes: "Holdings Investment")

    end

    investment
  end

  def active_secondary_sale
    entity.secondary_sales.where("secondary_sales.start_date <= ? and secondary_sales.end_date >= ?",
                                 Time.zone.today, Time.zone.today).first
  end

  def holder_name
    user ? user.full_name : investor.investor_name
  end
end
