class Offer < ApplicationRecord
  belongs_to :user
  belongs_to :entity
  belongs_to :secondary_sale
  belongs_to :holding

  delegate :quantity, to: :holding, prefix: :holding

  validates :quantity, comparison: { less_than_or_equal_to: :holding_quantity }

  before_save :set_percentage
  def set_percentage
    self.percentage = (100 * quantity) / holding.quantity
  end
end
