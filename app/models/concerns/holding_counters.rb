module HoldingCounters
  extend ActiveSupport::Concern

  INVESTMENT_FOR = %w[Employee Founder].freeze
  EQUITY_LIKE = %w[Equity Preferred Options].freeze

  included do
    # Add the quantity to the investment
    counter_culture :investment,
                    column_name: proc { |h| h.call_counter_cache? ? 'quantity' : nil },
                    delta_column: 'quantity'

    counter_culture :investment,
                    column_name: proc { |h| h.call_counter_cache? ? 'amount_cents' : nil },
                    delta_column: 'value_cents'

    # Add the quantity to the aggregate_investment, counter culture does not
    # automatically update aggregate_investment even though the investment is updated
    counter_culture %i[investment aggregate_investment],
                    column_name: proc { |h| h.call_counter_cache? ? h.investment_instrument.downcase : nil },
                    delta_column: 'quantity'

    counter_culture %i[investment investee_entity],
                    column_name: proc { |h| h.call_counter_cache? ? h.investment_instrument.downcase : nil },
                    delta_column: 'quantity'

    counter_culture %i[investment investee_entity],
                    column_name: proc { |h| h.call_counter_cache? ? 'total_investments' : nil },
                    delta_column: 'value_cents'

    counter_culture :funding_round,
                    column_name: proc { |h| h.call_counter_cache? ? 'amount_raised_cents' : nil },
                    delta_column: 'value_cents'

    counter_culture :funding_round,
                    column_name: proc { |h| h.call_counter_cache? ? h.investment_instrument.downcase : nil },
                    delta_column: 'quantity'
  end

  def call_counter_cache?
    investment.scenario.actual? &&
      INVESTMENT_FOR.include?(holding_type) &&
      EQUITY_LIKE.include?(investment_instrument)
  end
end
