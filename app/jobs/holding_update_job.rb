class HoldingUpdateJob < ApplicationJob
  queue_as :default

  def perform(holding_id)
    holding = Holding.find(holding_id)
    holding.investment.update_percentage_holdings
  end
end
