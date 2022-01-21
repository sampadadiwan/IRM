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
end
