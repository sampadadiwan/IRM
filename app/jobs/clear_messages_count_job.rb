class ClearMessagesCountJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    DealInvestor.update(todays_messages_investor: 0, todays_messages_investee: 0)
  end
end
