# == Schema Information
#
# Table name: investors
#
#  id                 :integer          not null, primary key
#  investor_entity_id :integer
#  investee_entity_id :integer
#  category           :string(50)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  investor_name      :string(255)
#

class Investor < ApplicationRecord
  include Trackable

  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])
  acts_as_taggable_on :tags

  belongs_to :investor_entity, class_name: "Entity"
  belongs_to :investee_entity, class_name: "Entity"
  counter_culture :investee_entity

  has_many :investor_accesses, dependent: :destroy
  has_many :access_rights, foreign_key: :access_to_investor_id, dependent: :destroy
  has_many :deal_investors, dependent: :destroy
  has_many :deals, through: :deal_investors

  delegate :name, to: :investee_entity, prefix: :investee

  scope :for, lambda { |vc_user, startup_entity|
                where(investee_entity_id: startup_entity.id,
                      investor_entity_id: vc_user.entity_id)
              }

  scope :for_vc, ->(vc_user) { where(investor_entity_id: vc_user.entity_id) }
  scope :not_interacted, ->(no_of_days) { where("last_interaction_date < ? ", Time.zone.today - no_of_days.days) }

  INVESTOR_CATEGORIES = ENV["INVESTOR_CATEGORIES"].split(",") << "Prospective"

  def self.INVESTOR_CATEGORIES(entity = nil)
    Investment.INVESTOR_CATEGORIES(entity) + ["Prospective"]
  end

  before_save :update_name
  def update_name
    self.investor_name ||= "#{investor_entity.name} - #{investee_entity.name}"
    self.last_interaction_date ||= Time.zone.today - 10.years
  end

  def to_s
    "#{investor_name} : #{category}"
  end
end
