class Interest < ApplicationRecord
  belongs_to :user
  belongs_to :secondary_sale
  belongs_to :interest_entity, class_name: "Entity"
  belongs_to :offer_entity, class_name: "Entity"

  validates :quantity, comparison: { less_than_or_equal_to: :total_offered_quantity }
  validates :price, comparison: { less_than_or_equal_to: :max_price }
  validates :price, comparison: { greater_than_or_equal_to: :min_price }

  delegate :total_offered_quantity, to: :secondary_sale
  delegate :min_price, to: :secondary_sale
  delegate :max_price, to: :secondary_sale

  scope :short_listed, -> { where(short_listed: true) }
end
