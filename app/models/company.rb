class Company < ApplicationRecord
  has_rich_text :details
  has_many :interests, dependent: :destroy
  has_many :documents, as: :owner, dependent: :destroy

  TYPES = ["Home Office", "Institutional", "Public", "Private"]
end
