# == Schema Information
#
# Table name: deal_investors
#
#  id                       :integer          not null, primary key
#  deal_id                  :integer          not null
#  investor_id              :integer          not null
#  status                   :string(20)
#  primary_amount           :decimal(10, )
#  secondary_investment     :decimal(10, )
#  entity_id                :integer          not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  investor_entity_id       :integer
#  deleted_at               :datetime
#  impressions_count        :integer
#  unread_messages_investor :integer          default("0")
#  unread_messages_investee :integer          default("0")
#  todays_messages_investor :integer          default("0")
#  todays_messages_investee :integer          default("0")
#  pre_money_valuation      :decimal(20, 2)   default("0.00")
#  company_advisor          :string(100)
#  investor_advisor         :string(100)
#

class DealInvestor < ApplicationRecord
  include Trackable
  include Impressionable

  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  belongs_to :deal
  belongs_to :investor
  belongs_to :entity
  counter_culture :entity

  has_many :deal_activities, dependent: :destroy
  has_many :deal_messages, dependent: :destroy

  has_many :deal_docs, dependent: :destroy

  delegate :investor_name, to: :investor
  delegate :name, to: :entity, prefix: :entity
  delegate :name, to: :deal, prefix: :deal

  STATUS = %w[Active Pending Declined].freeze

  scope :for, ->(user) { where("investors.investor_entity_id=?", user.entity_id).joins(:investor) }
  scope :not_declined, -> { where("deal_investors.status<>?", "Declined").joins(:investor) }

  before_save :set_investor_entity_id
  def set_investor_entity_id
    self.investor_entity_id = investor.investor_entity_id
  end

  def to_s
    investor_name
  end

  def create_activites
    start_date = deal.start_date
    by_date = nil
    seq = 1
    days_to_completion = 0

    DealActivity.templates(deal).each do |template|
      if start_date
        days_to_completion += template.days
        by_date = start_date + days_to_completion.days
      end

      existing_activity = DealActivity.where(deal_id: deal_id, deal_investor_id: id)
                                      .where(title: template.title).first

      if existing_activity.present?
        existing_activity.update(sequence: template.sequence, days: template.days, by_date: by_date)
      else
        DealActivity.create(deal_id: deal_id, deal_investor_id: id,
                            entity_id: entity_id, title: template.title,
                            sequence: template.sequence, days: template.days,
                            by_date: by_date)
      end

      seq += 1
    end
  end

  def messages_viewed(current_user)
    if current_user.entity_id == investor_entity_id
      self.unread_messages_investor = 0
    else
      self.unread_messages_investee = 0
    end

    save
  end
end
