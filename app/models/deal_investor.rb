class DealInvestor < ApplicationRecord
  has_paper_trail
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

  belongs_to :deal
  belongs_to :investor
  belongs_to :entity

  has_many :deal_activities

  delegate :investor_name, to: :investor
  delegate :name, to: :entity, prefix: :entity
  delegate :name, to: :deal, prefix: :deal

  STATUS = ["Active", "Pending", "Declined"]
end
