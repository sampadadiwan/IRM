class AggregateInvestment < ApplicationRecord
  belongs_to :entity
  delegate :actual_scenario, to: :entity

  belongs_to :investor
  delegate :investor_name, to: :investor

  # Investments which belong to the Actual scenario are the real ones
  # All others are imaginary scenarios for planning and dont add to the real
  belongs_to :scenario

  def update_percentage
    entity.aggregate_investments.each do |ai|
      eq = (entity.equity + entity.preferred)
      ai.percentage = 100.0 * (ai.equity + ai.preferred) / eq if eq.positive?

      eq_op = (entity.equity + entity.preferred + entity.options)
      ai.full_diluted_percentage = 100.0 * (ai.equity + ai.preferred + ai.options) / eq_op if eq_op.positive?

      ai.save
    end
  end

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
