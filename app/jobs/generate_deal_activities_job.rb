class GenerateDealActivitiesJob < ApplicationJob
  queue_as :default

  def perform(id, class_name)
    if class_name == "Deal"
      @deal = Deal.find(id)
      @deal.create_activities
    elsif class_name == "DealInvestor"
      @deal_investor = DealInvestor.find(id)
      @deal_investor.create_activities
    end
  end
end
