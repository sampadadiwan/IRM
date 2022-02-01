class DealActivity < ApplicationRecord
  has_paper_trail
  acts_as_list scope: [:deal_investor, :deal], column: :sequence

  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

  default_scope { order(sequence: :asc) }

  belongs_to :deal
  belongs_to :deal_investor, optional: true
  belongs_to :entity

  has_many :deal_docs, dependent: :destroy


  delegate :investor_name, to: :deal_investor, allow_nil: true
  delegate :name, to: :entity, prefix: :entity
  delegate :name, to: :deal, prefix: :deal

  has_rich_text :details

  scope :templates,  ->(deal) { where(deal_id: deal.id).where(deal_investor_id:nil) }

  before_save :set_defaults

  def set_defaults
    self.status = "Template" if self.deal_investor_id == nil
  end
  
  def completed_status
    self.completed ? "Yes" : "No"
  end

  def summary
    self.status.present? ? self.status : completed_status
  end

end
