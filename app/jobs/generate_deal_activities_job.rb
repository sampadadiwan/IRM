class GenerateDealActivitiesJob < ApplicationJob
  queue_as :default

  def perform(deal_id)
    @deal = Deal.find(deal_id)
    @deal.create_activites
  end
end
