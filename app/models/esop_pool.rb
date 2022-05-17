class EsopPool < ApplicationRecord
  belongs_to :entity
  belongs_to :funding_round, optional: true
  has_many :vesting_schedules, inverse_of: :esop_pool, dependent: :destroy
  accepts_nested_attributes_for :vesting_schedules, reject_if: :all_blank, allow_destroy: true

  validates :name, :start_date, :number_of_options, :excercise_price, presence: true

  monetize :excercise_price_cents, with_currency: ->(i) { i.entity.currency }
end
