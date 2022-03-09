# == Schema Information
#
# Table name: deals
#
#  id                :integer          not null, primary key
#  entity_id         :integer          not null
#  name              :string(255)
#  amount_cents      :decimal(10, )
#  status            :string(20)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  activity_list     :text(65535)
#  start_date        :date
#  end_date          :date
#  deleted_at        :datetime
#  impressions_count :integer          default("0")
#  archived          :boolean          default("0")
#  currency          :string(10)
#  units             :string(15)
#

class Deal < ApplicationRecord
  include Trackable
  include Impressionable

  encrypts :name
  monetize :amount_cents, with_model_currency: ->(i) { i.currency }

  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  belongs_to :entity
  counter_culture :entity

  has_many :deal_investors, dependent: :destroy
  has_many :investors, through: :deal_investors

  has_many :deal_activities, dependent: :destroy

  has_many :deal_docs, dependent: :destroy
  has_many :access_rights, as: :owner, dependent: :destroy

  STATUS = %w[Open Closed].freeze
  ACTIVITIES = Rack::Utils.parse_nested_query(ENV["DEAL_ACTIVITIES"].tr(":", "=").tr(",", "&"))

  before_create :set_defaults
  def set_defaults; end

  def create_activites
    deal_investors.each(&:create_activites)
  end

  after_create :create_activity_template
  def create_activity_template
    seq = 1
    Deal::ACTIVITIES.each do |title, days|
      # Note that if deal_investor_id = nil then this is a template
      DealActivity.create!(deal_id: id, deal_investor_id: nil, status: "Template",
                           entity_id: entity_id, title: title, sequence: seq, days: days.to_i)
      seq += 1
    end
  end

  def start_deal
    self.start_date = Time.zone.today
    save
    GenerateDealActivitiesJob.perform_later(id)
  end

  def started?
    start_date != nil
  end

  def self.for_investor(user)
    Deal
      # Ensure the access rghts for Document
      .joins(:access_rights)
      .merge(AccessRight.for_access_type("Deal"))
      .joins(:investors)
      # Ensure that the user is an investor and tis investor has been given access rights
      .where("investors.investor_entity_id=?", user.entity_id)
      .where("investors.category=access_rights.access_to_category OR access_rights.access_to_investor_id=investors.id")
      # Ensure this user has investor access
      .joins(entity: :investor_accesses)
      .merge(InvestorAccess.approved_for_user(user))
      .where("investor_accesses.entity_id = deals.entity_id")
  end

  def to_s
    name
  end

  def activity_names
    DealActivity.templates(self).collect(&:title)
  end
end
