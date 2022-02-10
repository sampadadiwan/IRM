class InvestmentPercentageHoldingJob < ApplicationJob
  queue_as :default

  def perform(investment_id)
    investment = Investment.find(investment_id)
    investment.update_percentage_holdings
  end
end
