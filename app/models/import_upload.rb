class ImportUpload < ApplicationRecord
  belongs_to :entity
  belongs_to :owner, polymorphic: true
  belongs_to :user

  has_one_attached :import_file
end
