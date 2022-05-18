class Excercise < ApplicationRecord
  belongs_to :entity
  belongs_to :holding
  belongs_to :user
  belongs_to :esop_pool

  has_one_attached :payment_proof, service: :amazon

  monetize :price_cents, :amount_cents, with_currency: ->(e) { e.entity.currency }

  counter_culture :esop_pool,
                  column_name: proc { |e| e.approved && e.holding.update_esop_pool? ? 'excercised_quantity' : nil }, delta_column: 'quantity'

  counter_culture :holding,
                  column_name: proc { |e| e.approved ? 'excercised_quantity' : nil },
                  delta_column: 'quantity'

  validates :quantity, :price, :amount, presence: true
  validates :quantity, :price, :amount, numericality: { greater_than: 0 }
  validates :payment_proof, presence: true, on: :create
  validate :lapsed_holding, on: :create
  validate :validate_quantity, on: :update

  def lapsed_holding
    errors.add(:holding, "can't be lapsed") if holding.lapsed
    errors.add(:quantity, "can't be greater than #{holding.excercisable_quantity}") if quantity > holding.excercisable_quantity
  end

  def validate_quantity
    allowed = holding.excercisable_quantity + quantity_was
    errors.add(:quantity, "can't be greater than #{allowed}") if quantity > allowed
  end
end
