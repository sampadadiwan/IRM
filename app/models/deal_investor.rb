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
  

  scope :for, -> (user) { where("investors.investor_entity_id=?", user.entity_id).joins(:investor) }

  before_save :set_investor_entity_id
  def set_investor_entity_id
    self.investor_entity_id = self.investor.investor_entity_id
  end

  def create_activites
    start_date = self.deal.start_date    
    by_date = nil
    seq = 1
    days_to_completion = 0

    DealActivity.templates(self.deal).each do |template|

      if start_date
        days_to_completion += template.days
        by_date = start_date + days_to_completion.days
      end

      existing_activity = DealActivity.where(deal_id: self.deal_id, deal_investor_id: self.id).
                            where(title: template.title).first
      
      if existing_activity.present?
        existing_activity.update(sequence: template.sequence, days: template.days, by_date: by_date)
      else
        DealActivity.create(deal_id: self.deal_id, deal_investor_id: self.id, 
                            entity_id: self.entity_id, title: template.title, 
                            sequence: template.sequence, days: template.days,
                            by_date: by_date)
      end
      
      seq += 1
    end
  end
end
