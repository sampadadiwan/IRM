# == Schema Information
#
# Table name: secondary_sales
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  entity_id              :integer          not null
#  start_date             :date
#  end_date               :date
#  percent_allowed        :integer          default("0")
#  min_price              :decimal(20, 2)
#  max_price              :decimal(20, 2)
#  active                 :boolean          default("1")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  total_offered_quantity :integer          default("0")
#  visible_externally     :boolean          default("0")
#  deleted_at             :datetime
#

class SecondarySale < ApplicationRecord
  include Trackable
  include ActivityTrackable

  # Make all models searchable
  update_index('secondary_sale') { self }

  belongs_to :entity
  has_many :access_rights, as: :owner, dependent: :destroy
  has_many_attached :public_docs, service: :amazon
  has_many_attached :private_docs, service: :amazon

  has_many :offers, dependent: :destroy
  has_many :interests, dependent: :destroy

  monetize :total_offered_amount_cents, with_currency: ->(s) { s.entity.currency }
  monetize :total_interest_amount_cents, with_currency: ->(s) { s.entity.currency }

  validates :name, :start_date, :end_date, :min_price, :percent_allowed, presence: true

  scope :for, lambda { |user|
                where("access_rights.access_type='SecondarySale'")
                  .where("access_rights.access_to_investor_id = investors.id and investors.investor_entity_id=?", user.entity_id)
                  .joins(access_rights: :investor)
              }

  # before_save :set_defaults
  def update_allocation
    self.allocation_percentage = total_interest_quantity * 1.0 / total_offered_quantity if total_offered_quantity.positive?
    if allocation_percentage > 100
      # We have more interests than offers
      sql = "update interests set allocation_percentage = 100.00,
             allocation_quantity = quantity, allocation_amount_cents = (quantity * final_price)"
      ActiveRecord::Base.connection.execute(sql)
      # We only can allocate a portion of the offers
      inverse = (1.0 / allocation_percentage).round(2)
      logger.debug "allocating #{inverse}% of offers"
      sql = "update offers set allocation_percentage = #{100.00 * inverse},
             allocation_quantity = floor(quantity * #{inverse}),
             allocation_amount_cents = (floor(quantity * #{inverse}) * final_price)"
    else
      # We have more offers than interests
      sql = "update offers set allocation_percentage = 100.00,
             allocation_quantity = quantity, allocation_amount_cents = (quantity * final_price)"
      ActiveRecord::Base.connection.execute(sql)
      # We only can allocate a portion of the interests
      inverse = (1.0 / allocation_percentage).round(2)
      logger.debug "allocating #{inverse}% of interests"
      sql = "update interests set allocation_percentage = #{100.00 * inverse},
             allocation_quantity = floor(quantity * #{inverse}),
             allocation_amount_cents = (floor(quantity * #{inverse}) * final_price)"
    end
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.for_investor(user, entity)
    SecondarySale
      # Ensure the access rghts for Document
      .joins(:access_rights)
      .merge(AccessRight.access_filter)
      .joins(entity: :investors)
      # Ensure that the user is an investor and tis investor has been given access rights
      .where("entities.id=?", entity.id)
      .where("investors.investor_entity_id=?", user.entity_id)
      # Ensure this user has investor access
      .joins(entity: :investor_accesses)
      .merge(InvestorAccess.approved_for_user(user))
      .distinct
  end

  def active?
    start_date <= Time.zone.today && end_date >= Time.zone.today
  end

  def notify_advisors
    SecondarySaleMailer.with(id:).notify_advisors.deliver_later
  end

  def notify_open_for_offers
    SecondarySaleMailer.with(id:).notify_open_for_offers.deliver_later
  end

  def fix_final_price(price)
    self.final_price = price
    save
    update_offer_price
    update_interests_price
  end

  def update_offer_price
    offers.approved.each do |o|
      o.final_price = final_price
      o.save
    end
  end

  def update_interests_price
    interests.short_listed.each do |i|
      i.final_price = final_price
      i.save
    end
  end
end
