class HoldingUpdateJob < ApplicationJob
  queue_as :default

  def perform(holding_id)
    holding = Holding.find(holding_id)
    InvestmentPercentageHoldingJob.perform(holding.investment.id)
  end
end
