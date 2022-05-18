class Excercise < ApplicationRecord
  belongs_to :entity
  belongs_to :holding
  belongs_to :user
  belongs_to :esop_pool

  has_one_attached :payment_proof, service: :amazon

  monetize :price_cents, :amount_cents, :tax_cents, with_currency: ->(i) { i.entity.currency }

  counter_culture :esop_pool,
                  column_name: proc { |e| e.approved && e.holding.update_esop_pool? ? 'excercised_quantity' : nil }, delta_column: 'quantity'

  counter_culture :holding,
                  column_name: proc { |e| e.approved ? 'excercised_quantity' : nil },
                  delta_column: 'quantity'

  validates :quantity, :price, :amount, :tax, :tax_rate, presence: true
  validates :quantity, :amount, :tax_rate, numericality: { greater_than: 0 }
  validates :payment_proof, presence: true, on: :create
  validate :lapsed_holding

  def lapsed_holding
    errors.add(:holding, "can't be lapsed") if holding.lapsed
    errors.add(:quantity, "can't be greater than #{holding.excercisable_quantity}") if quantity > holding.excercisable_quantity
  end
end
