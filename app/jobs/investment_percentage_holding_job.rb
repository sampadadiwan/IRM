class InvestmentPercentageHoldingJob < ApplicationJob
  queue_as :default

  def perform(investment_id)
    investment = Investment.find(investment_id)
    # Ensure that all investments of the investee entity are adjusted for percentage
    update_investment_percentage(investment)
    # Ensure that all aggregate investments of the investee entity are adjusted for percentage
    update_aggregate_percentage(investment.aggregate_investment)
    # We also update the funding round to reflect the amount_raised
    investment.funding_round&.save
  end

  private

  def update_investment_percentage(investment)
    equity_investments = investment.scenario.investments.equity_or_pref
    esop_investments = investment.scenario.investments.options_or_esop
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

  def update_aggregate_percentage(aggregate_investment)
    all = aggregate_investment.scenario.aggregate_investments
    equity = all.sum(:equity)
    preferred = all.sum(:preferred)
    options = all.sum(:options)

    all.each do |ai|
      eq = (equity + preferred)
      ai.percentage = 100.0 * (ai.equity + ai.preferred) / eq if eq.positive?

      eq_op = (equity + preferred + options)
      ai.full_diluted_percentage = 100.0 * (ai.equity + ai.preferred + ai.options) / eq_op if eq_op.positive?

      ai.save
    end
  end
end
