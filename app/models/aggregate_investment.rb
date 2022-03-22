# == Schema Information
#
# Table name: aggregate_investments
#
#  id                      :integer          not null, primary key
#  entity_id               :integer          not null
#  shareholder             :string(255)
#  investor_id             :integer          not null
#  equity                  :integer          default("0")
#  preferred               :integer          default("0")
#  options                 :integer          default("0")
#  percentage              :decimal(5, 2)    default("0.00")
#  full_diluted_percentage :decimal(5, 2)    default("0.00")
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  scenario_id             :integer          not null
#

class AggregateInvestment < ApplicationRecord
  belongs_to :entity
  delegate :actual_scenario, to: :entity

  has_many :investments, dependent: :destroy

  belongs_to :investor
  delegate :investor_name, to: :investor

  # Investments which belong to the Actual scenario are the real ones
  # All others are imaginary scenarios for planning and dont add to the real
  belongs_to :scenario

  def self.for_investor(current_user, entity)
    actual_scenario = entity.actual_scenario
    investments = actual_scenario.aggregate_investments
                                 # Ensure the access rights for Investment
                                 .joins(entity: %i[investors access_rights])
                                 .merge(AccessRight.for_access_type("Investment"))
                                 # Ensure that the user is an investor and tis investor has been given access rights
                                 .where("entities.id=?", entity.id)
                                 .where("investors.investor_entity_id=?", current_user.entity_id)
                                 .where("investors.category=access_rights.access_to_category OR access_rights.access_to_investor_id=investors.id")
                                 # Ensure this user has investor access
                                 .joins(entity: :investor_accesses)
                                 .merge(InvestorAccess.approved_for(current_user, entity))

    # return investments if investments.blank?

    # Is this user from an investor
    investor = Investor.for(current_user, entity).first

    # Get the investor access for this user and this entity
    access_right = AccessRight.investments.investor_access(investor).last
    return Investment.none if access_right.nil?

    Rails.logger.debug access_right.to_json

    case access_right.metadata
    when AccessRight::ALL
      # Do nothing - we got all the investments
      logger.debug "Access to investor #{current_user.email} to ALL Entity #{entity.id} investments"
    when AccessRight::SELF
      # Got all the investments for this investor
      logger.debug "Access to investor #{current_user.email} to SELF Entity #{entity.id} investments"
      investments = investments.where(investor_id: investor.id)
    end

    investments
  end
end
