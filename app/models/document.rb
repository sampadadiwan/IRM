class Document < ApplicationRecord
    ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

    belongs_to :owner, polymorphic: true
    has_one_attached :file
    has_many :doc_accesses, dependent: :destroy
    has_rich_text :text

    def accessible_by?(category_or_email)
        self.doc_accesses.where(to: category_or_email).first.present?
    end

    def accessible?(user)
        if accessible_by?(user.email)
            logger.debug "Document #{self.id} accessible by email #{user.email}"
            true
        else
            # Find the investor
            investor = Investor.for_email_and_entity(user, self.owner_id).first
            if investor.present? && accessible_by?(investor.category)
                logger.debug "Document #{self.id} accessible by category #{investor.category} #{user.email}"
                true
            else
                logger.debug "Document #{self.id} NOT accessible by #{user.email}"
                false
            end
        end        
    end
end
