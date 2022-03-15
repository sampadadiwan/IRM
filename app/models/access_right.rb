# == Schema Information
#
# Table name: access_rights
#
#  id                    :integer          not null, primary key
#  owner_type            :string(255)      not null
#  owner_id              :integer          not null
#  access_to_email       :string(30)
#  access_to_investor_id :integer
#  access_type           :string(15)
#  metadata              :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  entity_id             :integer          not null
#  access_to_category    :string(20)
#  deleted_at            :datetime
#

class AccessRight < ApplicationRecord
  include Trackable
  include ActivityTrackable

  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  ALL = "All".freeze
  SELF = "Self".freeze
  SUMMARY = "Summary".freeze
  VIEWS = [ALL, SELF, SUMMARY].freeze
  TYPES = ["All Users for Specific Investor", "All Investors of Specific Category"].freeze

  belongs_to :owner, polymorphic: true
  belongs_to :entity
  belongs_to :investor, foreign_key: :access_to_investor_id, optional: true

  delegate :name, to: :entity, prefix: :entity
  delegate :name, to: :owner, prefix: :owner

  scope :investments, -> { where(access_type: "Investment") }
  scope :documents, -> { where(access_type: "Document") }
  scope :deals, -> { where(access_type: "Deal") }

  scope :for, ->(owner) { where(owner_id: owner.id, owner_type: owner.class.name) }
  scope :for_access_type, ->(type) { where("access_rights.access_type=?", type) }
  scope :for_investor, lambda { |investor|
                         where("(access_rights.entity_id=?
                                              and access_rights.access_to_investor_id is NULL
                                              and access_rights.access_to_category=?)
                                              OR (access_rights.access_to_investor_id=?)",
                               investor.investee_entity_id, investor.category, investor.id)
                       }

  scope :for_secondary_sale, lambda { |secondary_sale|
                               where("(access_rights.entity_id=?
                                             and access_rights.owner_id=?
                                             and access_rights.owner_type=?)",
                                     secondary_sale.entity_id, secondary_sale.id, "SecondarySale")
                             }

  scope :investor_access, lambda { |investor|
                            where(" (access_rights.entity_id=?) AND
                                    (access_rights.access_to_investor_id=? OR access_rights.access_to_category=?)",
                                  investor.investee_entity_id, investor.id, investor.category)
                          }

  validate :any_present?

  def any_present?
    errors.add :base, "Must specify Investor or Category" if %w[access_to_investor_id access_to_category].all? { |attr| self[attr].blank? }
  end

  def to_s
    access_to_label
  end

  def access_to_label
    label = ""

    label += "#{access_to_category}, " if access_to_category.present?
    label += "#{investor.investor_name}, " if access_to_investor_id.present?

    label[0..-3]
  end

  def investor_emails
    emails = []

    if access_to_investor_id.present?
      # Get all the investor -> investor access that are approved, and get the email addresses
      emails = investor.investor_accesses.approved.collect(&:email)
    elsif access_to_category.present?
      # Get all the investors with this category -> investor access that are approved, and get the email addresses
      investors = Investor.where(investee_entity_id: entity_id, category: access_to_category)
      investors.each do |investor|
        emails += investor.investor_accesses.approved.collect(&:email)
      end
    end

    emails
  end

  before_save :strip_fields
  def strip_fields
    self.access_to_category = access_to_category.strip if access_to_category
    self.metadata = metadata.strip if metadata
    self.access_type = access_type.strip if access_type
  end

  after_create :send_notification
  def send_notification
    AccessRightsMailer.with(access_right_id: id).notify_access.deliver_later
  end
end
