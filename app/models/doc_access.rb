class DocAccess < ApplicationRecord
    belongs_to :document
    delegate :owner, :to => :document, :allow_nil => true

    VISIBILITY = ["Category", "Email"]
end
