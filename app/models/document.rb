class Document < ApplicationRecord
    belongs_to :owner, polymorphic: true
    has_one_attached :file
    serialize :doc_type
    before_validation :sanitize_doc_types


    USER_TYPES = ["ID Proof", "Bank Statement"]
    COMPANY_TYPES = [""]


    def sanitize_doc_types
        self.doc_type = doc_type.reject(&:blank?)&.uniq
    end
end
