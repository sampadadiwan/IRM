class EsopPool < ApplicationRecord
  belongs_to :entity
  belongs_to :funding_round, optional: true

  has_many :holdings, inverse_of: :esop_pool, dependent: :destroy
  has_many :excercises, dependent: :destroy

  has_many :vesting_schedules, inverse_of: :esop_pool, dependent: :destroy
  accepts_nested_attributes_for :vesting_schedules, reject_if: :all_blank, allow_destroy: true

  has_many_attached :attachments, service: :amazon
  has_many_attached :excercise_instructions, service: :amazon

  validates :name, :start_date, :number_of_options, :excercise_price, presence: true
  validates :number_of_options, :excercise_price, numericality: { greater_than: 0 }

  validates :excercise_instructions, presence: true, on: :create unless Rails.env.test?
  validate :check_vesting_schedules

  before_create :setup_funding_round

  monetize :excercise_price_cents, with_currency: ->(i) { i.entity.currency }

  def setup_funding_round
    self.funding_round = FundingRound.create(name:, currency: entity.currency, entity_id:, status: "Open")
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

  def balance_quantity
    unexcercised_quantity - lapsed_quantity
  end

  def available_quantity
    number_of_options - allocated_quantity + lapsed_quantity
  end
end
