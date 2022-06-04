class HoldingAction < ApplicationRecord
  belongs_to :entity
  belongs_to :holding
  belongs_to :user
end
