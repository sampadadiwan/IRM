class InvestmentPercentageHoldingJob < ApplicationJob
  queue_as :default

  def perform(investment_id)
    investment = Investment.find(investment_id)
    # Ensure that all investments of the investee entity are adjusted for percentage
    investment.update_percentage
    # Ensure that all aggregate investments of the investee entity are adjusted for percentage
    investment.aggregate_investment.update_percentage
    # We also update the funding round to reflect the amount_raised
    investment.funding_round&.save
  end
end
