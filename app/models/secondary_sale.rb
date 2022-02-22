class SecondarySale < ApplicationRecord
  belongs_to :entity
  has_many :access_rights, as: :owner, dependent: :destroy
end
