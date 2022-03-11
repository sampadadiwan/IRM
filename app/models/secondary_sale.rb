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
#  min_price              :decimal(5, 2)
#  max_price              :decimal(5, 2)
#  active                 :boolean          default("1")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  total_offered_quantity :integer          default("0")
#  visible_externally     :boolean          default("0")
#

class SecondarySale < ApplicationRecord
  belongs_to :entity
  has_many :access_rights, as: :owner, dependent: :destroy
  has_many_attached :public_docs, service: :amazon
  has_many_attached :private_docs, service: :amazon

  has_many :offers, dependent: :destroy
  has_many :interests, dependent: :destroy

  validates :name, :start_date, :end_date, :min_price, :max_price, :percent_allowed, presence: true

  scope :for, lambda { |user|
                where("access_rights.access_type='SecondarySale'")
                  .where("access_rights.access_to_investor_id = investors.id and investors.investor_entity_id=?", user.entity_id)
                  .joins(access_rights: :investor)
              }

  def self.for_investor(user, entity)
    SecondarySale
      # Ensure the access rghts for Document
      .joins(:access_rights)
      .merge(AccessRight.for_access_type("SecondarySale"))
      .joins(entity: :investors)
      # Ensure that the user is an investor and tis investor has been given access rights
      .where("entities.id=?", entity.id)
      .where("investors.investor_entity_id=?", user.entity_id)
      .where("investors.category=access_rights.access_to_category OR access_rights.access_to_investor_id=investors.id")
      # Ensure this user has investor access
      .joins(entity: :investor_accesses)
      .merge(InvestorAccess.approved_for(user, entity))
  end

  def active?
    start_date <= Time.zone.today && end_date >= Time.zone.today
  end
end
