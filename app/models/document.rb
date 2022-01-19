class Document < ApplicationRecord
    belongs_to :owner, polymorphic: true
    has_one_attached :file
    serialize :visible_to
    before_validation :sanitize_visible_tos
    has_many :doc_visibilities, dependent: :destroy

    USER_TYPES = ["ID Proof", "Bank Statement"]
    COMPANY_TYPES = [""]
    

    def sanitize_visible_tos
        self.visible_to = visible_to.reject(&:blank?)&.uniq
    end
end
