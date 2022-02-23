class Offer < ApplicationRecord
  belongs_to :user
  belongs_to :entity
  belongs_to :secondary_sale
  belongs_to :holding

  delegate :quantity, to: :holding, prefix: :holding

  validates :quantity, comparison: { less_than_or_equal_to: :holding_quantity }
  validate :already_offered

  def already_offered
    errors.add(:secondary_sale, "An existing offer from this user already exists. Pl modify or delete that one.") if secondary_sale.offers.where(user_id: user_id).first.present?
  end

  before_save :set_percentage
  def set_percentage
    self.percentage = (100 * quantity) / holding.quantity
  end

  def allowed_quantity
    (holding.quantity * secondary_sale.percent_allowed / 100).round
  end
end
