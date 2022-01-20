class DocAccess < ApplicationRecord
    belongs_to :document
    delegate :owner, :to => :document, :allow_nil => true
    broadcasts_to :document

    VISIBILITY = ["Category", "Email"]
end
