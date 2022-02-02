class Document < ApplicationRecord
    resourcify
    has_paper_trail
    
    ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

    belongs_to :owner, polymorphic: true
    
    has_many :access_rights, as: :owner, dependent: :destroy

    has_rich_text :text

    has_attached_file :file,
        :s3_permissions => nil,
        :bucket => proc { |attachment| 
            attachment.instance.owner.s3_bucket.present? ? attachment.instance.owner.s3_bucket : ENV["AWS_S3_BUCKET"] 
        }

    validates_attachment_content_type :file, content_type: [/\Aimage\/.*\Z/, /\Avideo\/.*\Z/, /\Aaudio\/.*\Z/, /\Aapplication\/.*\Z/]
    
    validates_attachment :file, presence: true,
                        size: { in: 0..10.megabytes }

    
    def accessible?(user)
        investor = Investor.for(user, self.owner).first
        access_right = AccessRight.for(self).user_or_investor_access(user, investor).first

        self.owner_id == user.entity_id ||
            access_right.present?
        
    end

    def self.documents_for(current_user, entity)
        
        # Is this user from an investor
        investor = Investor.for(current_user, entity).first

        if investor.present? 

            documents = entity.documents.joins(:access_rights)
                            .where("access_rights.access_to=? or access_rights.access_to_investor_id=?", 
                                current_user.email, investor.id)
        
        else
            documents = entity.documents.joins(:access_rights)
                            .where("access_rights.access_to=?", current_user.email)
        
        end

        documents

    end
end
