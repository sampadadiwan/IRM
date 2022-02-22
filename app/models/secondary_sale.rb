class SecondarySale < ApplicationRecord
  belongs_to :entity
  has_many :access_rights, as: :owner, dependent: :destroy
  has_many :offers, dependent: :destroy

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
end
