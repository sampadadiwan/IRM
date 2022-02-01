class AccessRight < ApplicationRecord
  belongs_to :owner, polymorphic: true
end
