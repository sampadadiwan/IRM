class HoldingUpdateJob < ApplicationJob
  queue_as :default

  def perform(holding_id)
    holding = Holding.find(holding_id)
    InvestmentPercentageHoldingJob.perform_now(holding.investment.id)
  end
end
