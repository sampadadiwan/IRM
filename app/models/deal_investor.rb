class DealInvestor < ApplicationRecord
  has_paper_trail
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

  belongs_to :deal
  belongs_to :investor
  belongs_to :entity

  has_many :deal_activities, dependent: :destroy
  has_many :deal_messages, dependent: :destroy

  has_many :deal_docs, dependent: :destroy

  delegate :investor_name, to: :investor
  delegate :name, to: :entity, prefix: :entity
  delegate :name, to: :deal, prefix: :deal

  STATUS = ["Active", "Pending", "Declined"]

  after_create :create_activites
  def create_activites
    seq = 1
    DealActivity.templates(self.deal).each do |template|
      existing_activity = DealActivity.where(deal_id: self.deal_id, deal_investor_id: self.id).
                            where(title: template.title).first
      
      if existing_activity.present?
        existing_activity.update(sequence: template.sequence, days: template.days)
      else
        DealActivity.create(deal_id: self.deal_id, deal_investor_id: self.id, 
                            entity_id: self.entity_id, title: template.title, 
                            sequence: template.sequence, days: template.days)
      end
      
      seq += 1
    end
  end
end
