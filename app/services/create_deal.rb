class CreateDeal < Patterns::Service
  def initialize(deal)
    @deal = deal
  end

  def call
    Deal.transaction do
      deal.save
      set_active_deal
      create_activity_template
    end
    deal
  end

  private

  attr_reader :deal

  def set_active_deal
    deal.entity.active_deal_id = deal.id
    deal.entity.save
  end

  def create_activity_template
    seq = 1
    Deal::ACTIVITIES.each do |title, days|
      # Note that if deal_investor_id = nil then this is a template
      DealActivity.create!(deal_id: deal.id, deal_investor_id: nil, status: "Template",
                           entity_id: deal.entity_id, title:, sequence: seq, days: days.to_i)
      seq += 1
    end
  end
end
