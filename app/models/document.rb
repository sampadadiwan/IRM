class Document < ApplicationRecord
    ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

    belongs_to :owner, polymorphic: true
    has_one_attached :file
    has_many :doc_accesses, dependent: :destroy

    serialize :visible_to
    before_validation :sanitize_visible_tos

    USER_TYPES = ["ID Proof", "Bank Statement"]
    COMPANY_TYPES = [""]
    

    def sanitize_visible_tos
        self.visible_to = visible_to.reject(&:blank?)&.uniq
    end

    def accessible_by?(category_or_email)
        self.doc_accesses.where(to: category_or_email).first.present?
    end

    def accessible?(user)
        if accessible_by?(user.email)
            logger.debug "Document #{self.id} accessible by email #{user.email}"
            true
        else
            # Find the investor
            investor = Investor.investors_for_email_and_entity(user, self.owner_id).first
            if investor.present? && accessible_by?(investor.category)
                logger.debug "Document #{self.id} accessible by category #{investor.category} #{user.email}"
                true
            else
                logger.debug "Document #{self.id} NOT accessible by category #{investor.category} #{user.email}"
                false
            end
        end        
    end
end
