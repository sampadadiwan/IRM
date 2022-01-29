class DealMessage < ApplicationRecord
  belongs_to :user
  belongs_to :deal_investor
  has_rich_text :content

  scope :user_messages,  ->(user) { where("deal_messages.id =? OR deal_investors.entity_id=? OR investors.investor_entity_id=?", 
      user.id, user.entity_id, user.entity_id).joins(:deal_investor=>[:investor]).includes(:deal_investor=>:investor) }

end
