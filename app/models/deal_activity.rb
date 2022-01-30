class DealActivity < ApplicationRecord
  has_paper_trail
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

  default_scope { order(by_date: :asc) }

  belongs_to :deal
  belongs_to :deal_investor, optional: true
  belongs_to :entity

  has_many :deal_docs, dependent: :destroy


  delegate :investor_name, to: :deal_investor, allow_nil: true
  delegate :name, to: :entity, prefix: :entity
  delegate :name, to: :deal, prefix: :deal

  has_rich_text :details

  scope :templates,  ->(deal) { where(deal_id: deal.id).where(deal_investor_id:nil) }

  
  def completed_status
    self.completed ? "Yes" : "No"
  end

  def due_by
  end

  def summary
    self.status.present? ? self.status : completed_status
  end

end
