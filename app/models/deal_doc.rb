class DealDoc < ApplicationRecord
  has_paper_trail
    
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

  belongs_to :deal
  belongs_to :deal_investor, optional: true
  belongs_to :deal_activity, optional: true
  belongs_to :user

  delegate :investor_name, to: :deal_investor
  delegate :name, to: :deal, prefix: :deal


  has_attached_file :file,
                    :s3_permissions => nil,
                    :bucket => proc { |attachment| 
                        attachment.instance.deal.entity.s3_bucket.present? ? 
                              attachment.instance.deal.entity.s3_bucket : ENV["AWS_S3_BUCKET"] 
                    }

  validates_attachment_content_type :file, content_type: [/\Aimage\/.*\Z/, /\Avideo\/.*\Z/, /\Aaudio\/.*\Z/, /\Aapplication\/.*\Z/]

  validates_attachment :file, presence: true,
                        size: { in: 0..10.megabytes }


  scope :user_deal_docs,  ->(user) { where("deal_docs.user_id =? OR deals.entity_id=? OR 
                                            deal_investors.entity_id=? OR investors.investor_entity_id=?", 
                                      user.id, user.entity_id, user.entity_id, user.entity_id).
                                      joins(:deal, :deal_investor=>[:investor]).
                                      includes(:deal, :deal_investor=>:investor) }
                                                  
end
