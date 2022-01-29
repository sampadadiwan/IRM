class Deal < ApplicationRecord
  has_paper_trail
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

  belongs_to :entity
  has_many :deal_investors
  has_many :investors, through: :deal_investors
  has_many :deal_activities
  
  STATUS = ["Open", "Closed"]
end
