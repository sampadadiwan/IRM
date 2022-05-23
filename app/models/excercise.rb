class Excercise < ApplicationRecord
  belongs_to :entity
  belongs_to :holding
  belongs_to :user
  belongs_to :esop_pool

  has_one_attached :payment_proof, service: :amazon

  monetize :price_cents, :amount_cents, with_currency: ->(e) { e.entity.currency }

  counter_culture :esop_pool,
                  column_name: proc { |e| e.approved ? 'excercised_quantity' : nil },
                  delta_column: 'quantity'

  counter_culture :holding,
                  column_name: proc { |e| e.approved ? 'excercised_quantity' : nil },
                  delta_column: 'quantity'

  validates :quantity, :price, :amount, presence: true
  validates :quantity, :price, :amount, numericality: { greater_than: 0 }
  validates :payment_proof, presence: true, on: :create unless Rails.env.test?
  validate :lapsed_holding, on: :create
  validate :validate_quantity, on: :update

  before_save :compute
  after_create :notify_excercise
  after_update :post_approval

  def compute
    self.amount_cents = quantity * price_cents
  end

  def lapsed_holding
    errors.add(:holding, "can't be lapsed") if holding.lapsed
    errors.add(:quantity, "can't be greater than #{holding.excercisable_quantity}") if quantity > holding.excercisable_quantity
  end

  def validate_quantity
    allowed = holding.excercisable_quantity
    # if new_record?
    # end
    errors.add(:quantity, "can't be greater than #{allowed}") if quantity > allowed
  end

  def notify_excercise
    ExcerciseMailer.with(excercise_id: id).notify_excercise.deliver_later
  end

  def post_approval
    if saved_change_to_approved? && approved
      ExcerciseMailer.with(excercise_id: id).notify_approval.deliver_later
      # Updates the existing Holding quantity
      holding.reload.save
      # Generate the equity holding to update the cap table
      Holding.create(user_id:, entity_id:, quantity:, price_cents:, investment_instrument: "Equity", investor_id: holding.investor_id, holding_type: holding.holding_type, funding_round_id: esop_pool.funding_round_id, employee_id: holding.employee_id, created_from_excercise_id: id)
    end
  end
end
