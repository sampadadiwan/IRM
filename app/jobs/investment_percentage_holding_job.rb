class InvestmentPercentageHoldingJob < ApplicationJob
  queue_as :default

  def perform(investment_id)
    Chewy.strategy(:sidekiq) do
      Rails.logger.debug { "InvestmentPercentageHoldingJob: Started #{investment_id}" }
      investment = Investment.find(investment_id)
      # Ensure that all investments of the investee entity are adjusted for percentage
      update_investment_percentage(investment)
      # Ensure that all aggregate investments of the investee entity are adjusted for percentage
      update_aggregate_percentage(investment.aggregate_investment) if investment.aggregate_investment
      # We also update the funding round to reflect the amount_raised
      investment.funding_round&.save

      Rails.logger.debug { "InvestmentPercentageHoldingJob: Completed #{investment_id}" }
    end
  end

  private

  def update_investment_percentage(investment)
    equity_investments = investment.scenario.investments.equity_or_pref
    esop_investments = investment.scenario.investments.options_or_esop
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

  def update_aggregate_percentage(aggregate_investment)
    all = aggregate_investment.scenario.aggregate_investments
    equity = all.sum(:equity)
    preferred = all.sum(:preferred)
    options = all.sum(:options)

    eq = (equity + preferred).positive? ? (equity + preferred) : 1
    eq_op = (equity + preferred + options).positive? ? (equity + preferred + options) : 1

    all.update_all("percentage = 100*(equity+preferred)/#{eq},
                    full_diluted_percentage = 100*(equity+preferred+options)/#{eq_op}")
  end
end
