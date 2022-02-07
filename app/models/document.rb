# == Schema Information
#
# Table name: documents
#
#  id                :integer          not null, primary key
#  name              :string(100)
#  visible_to        :string(255)      default("--- []\n")
#  text              :string(255)      default("--- []\n")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  entity_id         :integer          not null
#

class Document < ApplicationRecord
  resourcify
  has_paper_trail

  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  has_many :access_rights, as: :owner, dependent: :destroy
  has_many :investors, as: :owner
  belongs_to :entity

  has_rich_text :text
  has_one_attached :video, service: :amazon

  has_attached_file :file,
                    bucket: proc { |attachment|
                      attachment.instance.entity.s3_bucket.present? ? attachment.instance.owner.s3_bucket : ENV["AWS_S3_BUCKET"]
                    }

  validates_attachment_content_type :file, content_type: [%r{\Aimage/.*\Z}, %r{\Avideo/.*\Z}, %r{\Aaudio/.*\Z}, %r{\Aapplication/.*\Z}]

  validates_attachment_size :file, # presence: false,
                            less_than: 10.megabytes,
                            message: 'must be smaller than 10mb. Use video upload if needed for large video files'

  def self.documents_for(current_user, entity)
    # Is this user from an investor
    investor = Investor.for(current_user, entity).first

    if investor.present?

      entity.documents.joins(:access_rights)
            .where("access_rights.access_to=? or access_rights.access_to_investor_id=?",
                   current_user.email, investor.id)

    else
      entity.documents.joins(:access_rights)
            .where("access_rights.access_to=?", current_user.email)

    end
  end

  def self.for_investor(user, entity)
    category_access = Document
                      .joins(:access_rights)
                      .merge(AccessRight.for_access_type("Document"))
                      .joins(entity: :investors)
                      .where("entities.id=?", entity.id)
                      .where("investors.investor_entity_id=?", user.entity_id)
                      .where("investors.category=access_rights.access_to_category")

    direct_access = Document
                    .merge(AccessRight.for_access_type("Document"))
                    .merge(AccessRight.user_access(user))
                    .joins(:access_rights)
                    .joins(entity: :investors)
                    .where("entities.id=?", entity.id)

    # direct_access
    # category_access
    direct_access.or(category_access).distinct
  end

  def is_video?
    file_content_type =~ /video/
  end
end
