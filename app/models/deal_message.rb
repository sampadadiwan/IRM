class DealMessage < ApplicationRecord
  belongs_to :user
  belongs_to :deal_investor
  has_rich_text :content

  scope :user_messages,  ->(user) { where("deal_messages.user_id =? OR deal_investors.entity_id=? OR investors.investor_entity_id=?", 
      user.id, user.entity_id, user.entity_id).joins(:deal_investor=>[:investor]).includes(:deal_investor=>:investor) }

  after_create_commit { broadcast_append_to "deal_investor_#{self.deal_investor_id}", target: "deal_investor_#{self.deal_investor_id}",  
                        partial: "deal_messages/conversation_msg", locals: {msg: self} }

end
