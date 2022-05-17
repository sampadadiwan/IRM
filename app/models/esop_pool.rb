class EsopPool < ApplicationRecord
  belongs_to :entity
  belongs_to :funding_round, optional: true
  has_many :holdings, dependent: :destroy
  has_many :vesting_schedules, inverse_of: :esop_pool, dependent: :destroy
  accepts_nested_attributes_for :vesting_schedules, reject_if: :all_blank, allow_destroy: true

  has_many_attached :attachments, service: :amazon

  validates :name, :start_date, :number_of_options, :excercise_price, presence: true

  monetize :excercise_price_cents, with_currency: ->(i) { i.entity.currency }

  def get_allowed_percentage(grant_date)
    # Find the percentage that can be excercised
    schedules = vesting_schedules.order(months_from_grant: :asc)
    allowed_percentage = 0

    schedules.each do |sched|
      allowed_percentage += sched.vesting_percentage if grant_date + sched.months_from_grant.months <= Time.zone.now
    end

    logger.debug "excercisable_quantity allowed_percentage: #{allowed_percentage}"
    allowed_percentage
  end
end
