class Document < ApplicationRecord
    resourcify
    has_paper_trail
    
    ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

    has_many :access_rights, as: :owner, dependent: :destroy
    has_many :investors, as: :owner
    belongs_to :entity

    has_rich_text :text

    has_attached_file :file,
        :s3_permissions => nil,
        :bucket => proc { |attachment| 
            attachment.instance.entity.s3_bucket.present? ? attachment.instance.owner.s3_bucket : ENV["AWS_S3_BUCKET"] 
        }

    validates_attachment_content_type :file, content_type: [/\Aimage\/.*\Z/, /\Avideo\/.*\Z/, /\Aaudio\/.*\Z/, /\Aapplication\/.*\Z/]
    
    validates_attachment :file, presence: true,
                        size: { in: 0..10.megabytes }

    

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

    def self.invested_entities_documents(user)
        category_access = Document.joins(:owner=>:investors).
          where("investors.investor_entity_id": user.entity_id).
          where("investors.category=access_rights.access_to_category").
          joins(:access_rights).
          merge(AccessRight.for_access_type("Document"))
          
    
        direct_access = Document.joins(:owner=>:investors).
          merge(AccessRight.for_access_type("Document")).
          merge(AccessRight.user_access(user)).
          joins(:access_rights) 
    
        direct_access.or(category_access)
    end
    
end
