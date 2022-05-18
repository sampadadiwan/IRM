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
#  funding_round_id      :integer          not null
#

class Holding < ApplicationRecord
  include HoldingCounters
  include HoldingScopes

  update_index('holding') { self }

  belongs_to :user, optional: true
  belongs_to :entity
  belongs_to :funding_round, optional: true
  belongs_to :investor
  # This is only for options
  belongs_to :esop_pool, optional: true
  has_many :offers, dependent: :destroy
  has_many :excercises, dependent: :destroy

  # Only update the investment if its coming from an employee of a holding company
  before_validation :setup_investment, if: proc { |h| INVESTMENT_FOR.include?(h.holding_type) }
  before_save :update_value

  belongs_to :investment
  has_one :aggregated_investment, through: :investment

  monetize :price_cents, :value_cents, with_currency: ->(i) { i.entity.currency }

  validates :quantity, :holding_type, presence: true

  scope :investors, -> { where(holding_type: "Investor") }
  scope :employees, -> { where(holding_type: "Employee") }
  scope :founders, -> { where(holding_type: "Founder") }
  scope :lapsed, -> { where(lapsed: true) }

  scope :eq_and_pref, -> { where(investment_instrument: %w[Equity Preferred]) }

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
                                          investment_instrument:,
                                          category: holding_type, investee_entity_id: entity.id,
                                          investor_id: employee_investor.id, employee_holdings: true,
                                          quantity: 0, price_cents:,
                                          currency: entity.currency, funding_round:,
                                          scenario: entity.actual_scenario, notes: "Holdings Investment")

    end

    investment
  end

  def active_secondary_sale
    entity.secondary_sales.where("secondary_sales.start_date <= ? and secondary_sales.end_date >= ?",
                                 Time.zone.today, Time.zone.today).last
  end

  def holder_name
    user ? user.full_name : investor.investor_name
  end

  def unvested_quantity
    vested_quantity - excercised_quantity
  end

  def balance_quantity
    unvested_quantity - lapsed_quantity
  end

  def lapsed?
    grant_date + esop_pool.excercise_period_months.months < Time.zone.today
  end

  def lapsed_quantity
    lapsed ? unvested_quantity : 0
  end

  def allowed_percentage
    esop_pool.get_allowed_percentage(grant_date)
  end

  def excercisable_quantity
    percentage = allowed_percentage

    if percentage.positive?
      # Get the already excercised quantity
      (percentage * quantity / 100.0) - excercised_quantity
    else
      0
    end
  end

  def excercisable?
    investment_instrument == "Options" &&
      vested_quantity.positive? &&
      !lapsed
  end
end
