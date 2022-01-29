class DealActivity < ApplicationRecord
  has_paper_trail
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

  belongs_to :deal
  belongs_to :deal_investor
  belongs_to :entity

  delegate :investor_name, to: :deal_investor
  delegate :name, to: :entity, prefix: :entity
  delegate :name, to: :deal, prefix: :deal

  has_rich_text :details
  
  def completed_status
    completed ? "Yes" : "No"
  end

end
