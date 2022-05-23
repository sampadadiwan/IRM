# == Schema Information
#
# Table name: option_pools
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  start_date              :date
#  number_of_options       :integer          default("0")
#  excercise_price_cents   :decimal(20, 2)   default("0.00")
#  excercise_period_months :integer          default("0")
#  entity_id               :integer          not null
#  funding_round_id        :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  allocated_quantity      :integer          default("0")
#  excercised_quantity     :integer          default("0")
#  vested_quantity         :integer          default("0")
#  lapsed_quantity         :integer          default("0")
#  approved                :boolean          default("0")
#

class OptionPool < ApplicationRecord
  belongs_to :entity
  belongs_to :funding_round, optional: true

  has_many :holdings, inverse_of: :option_pool, dependent: :destroy
  has_many :excercises, dependent: :destroy

  has_many :vesting_schedules, inverse_of: :option_pool, dependent: :destroy
  accepts_nested_attributes_for :vesting_schedules, reject_if: :all_blank, allow_destroy: true

  has_many_attached :attachments, service: :amazon
  has_many_attached :excercise_instructions, service: :amazon

  validates :name, :start_date, :number_of_options, :excercise_price, presence: true
  validates :number_of_options, :excercise_price, numericality: { greater_than: 0 }

  validates :excercise_instructions, presence: true, on: :create unless Rails.env.test?
  validate :check_vesting_schedules

  before_save :setup_trust_holdings, if: :approved
  before_create :setup_funding_round

  monetize :excercise_price_cents, with_currency: ->(i) { i.entity.currency }

  scope :approved, -> { where(approved: true) }

  def setup_funding_round
    self.funding_round = FundingRound.create(name:, currency: entity.currency, entity_id:, status: "Open")
  end

  # The unallocated options sit in the trust account
  def setup_trust_holdings
    logger.debug "Option pool has been approved. Setting up trust holdings"
    trust_investor = entity.investors.where(is_trust: true).first
    existing = Investment.where(funding_round_id:, investor_id: trust_investor.id, investment_instrument: "Options").first
    if existing.present?
      existing.quantity = number_of_options
      existing.save
    else
      Investment.create!(investee_entity_id: entity_id, quantity: number_of_options, price_cents: excercise_price_cents, investment_instrument: "Options", investor_id: trust_investor.id, funding_round_id:, scenario: entity.actual_scenario)
    end
  end

  def check_vesting_schedules
    total_percent = vesting_schedules.inject(0) { |sum, e| sum + e.vesting_percent }
    logger.debug vesting_schedules.to_json
    errors.add(:vesting_schedules, "Total percentage should be 100%") if total_percent != 100
  end

  def get_allowed_percentage(grant_date)
    Rails.logger.debug "called get_allowed_percentage"
    # Find the percentage that can be excercised
    schedules = vesting_schedules.order(months_from_grant: :asc)
    allowed_percentage = 0

    schedules.each do |sched|
      Rails.logger.debug { "Grant date: #{grant_date}, Schedule months_from_grant: #{sched.months_from_grant}" }
      allowed_percentage += sched.vesting_percent if grant_date + sched.months_from_grant.months <= Time.zone.now
    end

    logger.debug "excercisable_quantity allowed_percentage: #{allowed_percentage}"
    allowed_percentage
  end

  def unexcercised_quantity
    vested_quantity - excercised_quantity
  end

  def unvested_quantity
    number_of_options - vested_quantity
  end

  def balance_quantity
    unexcercised_quantity - lapsed_quantity
  end

  def available_quantity
    number_of_options - allocated_quantity + lapsed_quantity
  end
end
