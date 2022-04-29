# == Schema Information
#
# Table name: investors
#
#  id                               :integer          not null, primary key
#  investor_entity_id               :integer
#  investee_entity_id               :integer
#  category                         :string(100)
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  investor_name                    :string(255)
#  deleted_at                       :datetime
#  last_interaction_date            :date
#  investor_access_count            :integer          default("0")
#  unapproved_investor_access_count :integer          default("0")
#  is_holdings_entity               :boolean          default("0")
#

class Investor < ApplicationRecord
  # include Trackable
  update_index('investor') { self }

  # encrypts :investor_name, deterministic: true

  acts_as_taggable_on :tags

  belongs_to :investor_entity, class_name: "Entity"
  belongs_to :investee_entity, class_name: "Entity"
  counter_culture :investee_entity

  has_many :investor_accesses, dependent: :destroy

  has_many :access_rights, foreign_key: :access_to_investor_id, dependent: :destroy
  has_many :deal_investors, dependent: :destroy
  has_many :deals, through: :deal_investors
  has_many :holdings, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :aggregate_investments, dependent: :destroy

  delegate :name, to: :investee_entity, prefix: :investee
  validates :category, presence: true

  validates :investor_name, uniqueness: { scope: :investee_entity_id, message: "already exists as an investor. Duplicate Investor." }
  validates :investor_entity_id, uniqueness: { scope: :investee_entity_id, message: ": Investment firm already exists as an investor. Duplicate Investor." }

  scope :for, lambda { |vc_user, startup_entity|
                where(investee_entity_id: startup_entity.id,
                      investor_entity_id: vc_user.entity_id)
              }

  scope :for_vc, ->(vc_user) { where(investor_entity_id: vc_user.entity_id) }
  scope :not_holding, -> { where(is_holdings_entity: false) }
  scope :holding, -> { where(is_holdings_entity: true) }
  scope :not_interacted, ->(no_of_days) { where(is_holdings_entity: false).where("last_interaction_date < ? ", Time.zone.today - no_of_days.days) }

  INVESTOR_CATEGORIES = ENV["INVESTOR_CATEGORIES"].split(",") << "Prospective"

  def self.INVESTOR_CATEGORIES(entity = nil)
    Investment.INVESTOR_CATEGORIES(entity) + ["Prospective"]
  end

  before_validation :update_name
  def update_name
    self.investor_name = investor_entity.name if investor_name.blank?
    self.last_interaction_date ||= Time.zone.today - 10.years

    # Ensure we have an investor entity
    if investor_entity_id.blank?
      e = Entity.where(name: investor_name).first
      e ||= Entity.create(name: investor_name, entity_type: "VC")
      self.investor_entity = e
    end
  end

  def to_s
    "#{investor_name} : #{category}"
  end
end
