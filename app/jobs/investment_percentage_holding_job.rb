class InvestmentPercentageHoldingJob < ApplicationJob
  queue_as :default

  def perform(scenario_id)
    Chewy.strategy(:sidekiq) do
      scenario = Scenario.find(scenario_id)
      if scenario.percentage_in_progress

        Rails.logger.debug { "InvestmentPercentageHoldingJob: Started #{scenario_id}" }

        # Ensure that all investments of the investee entity are adjusted for percentage
        update_investment_percentage(scenario)
        # Ensure that all aggregate investments of the investee entity are adjusted for percentage
        update_aggregate_percentage(scenario) if scenario.aggregate_investments.present?

        scenario.percentage_in_progress = false
        scenario.save

        Rails.logger.debug { "InvestmentPercentageHoldingJob: Completed #{scenario_id}" }
      end
    end
  end

  private

  def update_investment_percentage(scenario)
    equity_investments = scenario.investments.equity_or_pref
    esop_investments = scenario.investments.options_or_esop
    equity_quantity = equity_investments.sum(:quantity)
    esop_quantity = esop_investments.sum(:quantity)

    equity_investments.update_all(
      "percentage_holding = quantity * 100.0 / #{equity_quantity},
         diluted_percentage = quantity * 100.0 / (#{equity_quantity + esop_quantity})"
    )

    esop_investments.update_all(
      "percentage_holding = 0,
       diluted_percentage = quantity * 100.0 / (#{equity_quantity + esop_quantity})"
    )
  end

  def update_aggregate_percentage(scenario)
    all = scenario.aggregate_investments
    equity = all.sum(:equity)
    preferred = all.sum(:preferred)
    options = all.sum(:options)

    eq = (equity + preferred).positive? ? (equity + preferred) : 1
    eq_op = (equity + preferred + options).positive? ? (equity + preferred + options) : 1

    all.update_all("percentage = 100*(equity+preferred)/#{eq},
                    full_diluted_percentage = 100*(equity+preferred+options)/#{eq_op}")
  end
end
