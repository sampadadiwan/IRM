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

  counter_culture :secondary_sale,
                  column_name: proc { |o| o.approved ? 'total_offered_amount_cents' : nil },
                  delta_column: 'amount_cents'

  belongs_to :holding
  belongs_to :granter, class_name: "User", foreign_key: :granted_by_user_id, optional: true
  belongs_to :buyer, class_name: "Entity", optional: true

  has_many_attached :docs, service: :amazon
  has_many_attached :signature, service: :amazon
  has_many_attached :buyer_docs, service: :amazon

  delegate :quantity, to: :holding, prefix: :holding

  scope :approved, -> { where(approved: true) }
  scope :pending_approval, -> { where(approved: false) }

  validate :check_quantity
  validate :already_offered, :sale_active, on: :create

  BUYER_STATUS = %w[Confirmed Rejected].freeze

  def already_offered
    errors.add(:secondary_sale, ": An existing offer from this user already exists. Pl modify or delete that one.") if secondary_sale.offers.where(user_id:, holding_id:).first.present?
  end

  def sale_active
    errors.add(:secondary_sale, ": Is not active.") unless secondary_sale.active?
  end

  before_save :set_defaults
  def set_defaults
    self.percentage = (100.0 * quantity) / total_holdings_quantity

    self.investor_id = holding.investor_id
    self.user_id = holding.user_id if holding.user_id
    self.entity_id = holding.entity_id

    self.approved = false if quantity_changed?

    self.amount_cents = quantity * final_price if final_price.positive?
  end

  def check_quantity
    # holding users total holding amount
    total_quantity = total_holdings_quantity
    Rails.logger.debug { "total_holdings_quantity: #{total_quantity}" }

    # already offered amount
    already_offered = secondary_sale.offers.where(user_id: holding.user_id).sum(:quantity)
    Rails.logger.debug { "already_offered: #{already_offered}" }

    total_offered_quantity = already_offered + quantity
    total_offered_quantity -= quantity_was unless new_record?
    Rails.logger.debug { "total_offered_quantity: #{total_offered_quantity}" }

    errors.add(:quantity, ": total offered quantity is > total holdings") if total_offered_quantity > total_quantity
  end

  def total_holdings_quantity
    holding.user ? holding.user.holdings.eq_and_pref.sum(:quantity) : holding.investor.holdings.eq_and_pref.sum(:quantity)
  end

  def allowed_quantity
    # holding users total holding amount
    (total_holdings_quantity * secondary_sale.percent_allowed / 100).round
  end
end
