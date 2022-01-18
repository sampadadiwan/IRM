class Document < ApplicationRecord
    belongs_to :owner, polymorphic: true
    has_one_attached :file

    USER_TYPES = ["ID Proof", "Bank Statement"]
    COMPANY_TYPES = [""]
end
