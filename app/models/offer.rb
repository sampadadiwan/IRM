# == Schema Information
#
# Table name: offers
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  entity_id          :integer          not null
#  secondary_sale_id  :integer          not null
#  quantity           :integer          default("0")
#  percentage         :decimal(10, )    default("0")
#  notes              :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  holding_id         :integer          not null
#  approved           :boolean          default("0")
#  granted_by_user_id :integer
#  investor_id        :integer          not null
#  offer_type         :string(15)
#

class Offer < ApplicationRecord
  belongs_to :user
  belongs_to :investor
  belongs_to :entity
  belongs_to :secondary_sale
  counter_culture :secondary_sale,
                  column_name: proc { |o| o.approved ? 'total_offered_quantity' : nil },
                  delta_column: 'quantity'

  belongs_to :holding
  belongs_to :granter, class_name: "User", foreign_key: :granted_by_user_id, optional: true

  delegate :quantity, to: :holding, prefix: :holding

  validates :quantity, comparison: { less_than_or_equal_to: :holding_quantity }
  validate :already_offered, :sale_active, on: :create

  def already_offered
    errors.add(:secondary_sale, "An existing offer from this user already exists. Pl modify or delete that one.") if secondary_sale.offers.where(user_id:, holding_id:).first.present?
  end

  def sale_active
    errors.add(:secondary_sale, "Is not active.") unless secondary_sale.active?
  end

  before_save :set_defaults
  def set_defaults
    self.percentage = (100 * quantity) / holding.quantity

    self.investor_id = holding.investor_id
    self.user_id = holding.user_id if holding.user_id
    self.entity_id = holding.entity_id
  end

  def allowed_quantity
    (holding.quantity * secondary_sale.percent_allowed / 100).round
  end
end
