# == Schema Information
#
# Table name: interests
#
#  id                 :integer          not null, primary key
#  offer_entity_id    :integer
#  quantity           :integer
#  price              :decimal(10, )
#  user_id            :integer          not null
#  interest_entity_id :integer
#  secondary_sale_id  :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  short_listed       :boolean          default("0")
#  escrow_deposited   :boolean          default("0")
#

class Interest < ApplicationRecord
  belongs_to :user
  belongs_to :secondary_sale
  belongs_to :interest_entity, class_name: "Entity"
  belongs_to :offer_entity, class_name: "Entity"

  validates :quantity, comparison: { less_than_or_equal_to: :total_offered_quantity }
  validates :price, comparison: { less_than_or_equal_to: :max_price } if proc { |i| i.secondary_sale.max_price }
  validates :price, comparison: { greater_than_or_equal_to: :min_price }

  delegate :total_offered_quantity, to: :secondary_sale
  delegate :min_price, to: :secondary_sale
  delegate :max_price, to: :secondary_sale

  scope :short_listed, -> { where(short_listed: true) }

  before_save :notify_shortlist, if: :short_listed
  after_create :notify_interest

  def notify_interest
    InterestMailer.with(interest_id: id).notify_interest.deliver_later
  end

  def notify_shortlist
    InterestMailer.with(interest_id: id).notify_shortlist.deliver_later if short_listed_changed?
  end
end
