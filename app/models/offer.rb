class Offer < ApplicationRecord
  belongs_to :user
  belongs_to :entity
  belongs_to :secondary_sale
  counter_culture :secondary_sale, column_name: 'total_offered_quantity', delta_column: 'quantity'

  belongs_to :holding
  belongs_to :granter, class_name: "User", foreign_key: :granted_by_user_id, optional: true

  delegate :quantity, to: :holding, prefix: :holding

  validates :quantity, comparison: { less_than_or_equal_to: :holding_quantity }
  validate :already_offered, :sale_active, on: :create

  def already_offered
    errors.add(:secondary_sale, "An existing offer from this user already exists. Pl modify or delete that one.") if secondary_sale.offers.where(user_id: user_id).first.present?
  end

  def sale_active
    errors.add(:secondary_sale, "Is not active.") unless secondary_sale.active?
  end

  before_save :set_percentage
  def set_percentage
    self.percentage = (100 * quantity) / holding.quantity
  end

  def allowed_quantity
    (holding.quantity * secondary_sale.percent_allowed / 100).round
  end
end
