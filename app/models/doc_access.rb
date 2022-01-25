class DocAccess < ApplicationRecord
    has_paper_trail
    
    belongs_to :document
    delegate :owner, :to => :document
    broadcasts_to :document

    VISIBILITY = ["Category", "Email"]

    scope :email_access,  ->(user) { where("doc_accesses.to": user.email) }
    scope :category_access,  ->(category) { where("doc_accesses.to": category) }    
    
    
end
