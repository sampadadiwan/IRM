# == Schema Information
#
# Table name: deals
#
#  id            :integer          not null, primary key
#  entity_id     :integer          not null
#  name          :string(100)
#  amount        :decimal(10, )
#  status        :string(20)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  activity_list :text(65535)
#  start_date    :date
#  end_date      :date
#

class Deal < ApplicationRecord
  resourcify
  has_paper_trail
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  belongs_to :entity

  has_many :deal_investors, dependent: :destroy
  has_many :investors, through: :deal_investors

  has_many :deal_activities, dependent: :destroy

  has_many :deal_docs, dependent: :destroy
  has_many :access_rights, as: :owner, dependent: :destroy

  STATUS = %w[Open Closed].freeze
  ACTIVITIES = Rack::Utils.parse_nested_query(ENV["DEAL_ACTIVITIES"].tr(":", "=").tr(",", "&"))

  before_create :set_defaults
  def set_defaults
    self.activity_list ||= ACTIVITIES.to_json
  end

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
    self.start_date = Date.today
    save
    GenerateDealActivitiesJob.perform_later(id)
  end

  def self.for_investor(user)
    deal_access = Deal.joins(entity: :deal_investors)
                      .where("deal_investors.investor_entity_id=?", user.entity_id)
                      .joins(:access_rights)
                      .where("(access_rights.access_to_email = ?) OR
        (
          ( access_rights.access_to_email is null OR access_rights.access_to_email = '')
          AND access_rights.access_to_investor_id = deal_investors.investor_id
        )
        ", user.email)
    merge(AccessRight.for_access_type("Deal"))

    deal_access.distinct
  end
end
