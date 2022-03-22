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
    equity_investments = investment.scenario.investments.where(investee_entity_id: investee_entity_id).equity_or_pref
    esop_investments = investment.scenario.investments.where(investee_entity_id: investee_entity_id).options_or_esop
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

  def update_aggregate_percentage(_aggregate_investment)
    entity.aggregate_investments.each do |ai|
      eq = (entity.equity + entity.preferred)
      ai.percentage = 100.0 * (ai.equity + ai.preferred) / eq if eq.positive?

      eq_op = (entity.equity + entity.preferred + entity.options)
      ai.full_diluted_percentage = 100.0 * (ai.equity + ai.preferred + ai.options) / eq_op if eq_op.positive?

      ai.save
    end
  end
end
