class ImportUpload < ApplicationRecord
  belongs_to :entity
  belongs_to :owner, polymorphic: true
  belongs_to :user

  has_one_attached :import_file, service: :amazon
  validates :import_file,
            attached: true,
            content_type: ['application/xls', 'application/xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'],
            size: { less_than: 2.megabytes, message: 'must be less than 2MB in size' }

  after_create :run_import_job
  def run_import_job
    ImportUploadJob.perform_later(id)
  end
end
