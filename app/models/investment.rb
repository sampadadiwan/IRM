# == Schema Information
#
# Table name: investments
#
#  id                    :integer          not null, primary key
#  investment_type       :string(20)
#  investor_id           :integer
#  investor_type         :string(20)
#  investee_entity_id    :integer
#  status                :string(20)
#  investment_instrument :string(50)
#  quantity              :integer
#  initial_value         :decimal(20, )
#  current_value         :decimal(20, )
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  category              :string(25)
#

class Investment < ApplicationRecord
  has_paper_trail

  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  belongs_to :investor
  belongs_to :investee_entity, class_name: "Entity"

  # "Series A,Series B,Series C"
  INVESTMENT_TYPES = ENV["INVESTMENT_TYPES"].split(",")

  # "Equity,Preferred,Debt,ESOPs"
  INSTRUMENT_TYPES = ENV["INSTRUMENT_TYPES"].split(",")

  # "Lead Investor,Co-Investor,Founder,Individual,Employee"
  INVESTOR_CATEGORIES = ENV["INVESTOR_CATEGORIES"].split(",")

  scope :prospective, -> { where(investor_type: "Prospective") }
  scope :shareholders, -> { where(investor_type: "Shareholder") }

  # These functions override the defaults based on entities customization
  def self.INVESTMENT_TYPES(entity = nil)
    entity && entity.investment_types.present? ? entity.investment_types.split(",").map(&:strip) : INVESTMENT_TYPES
  end

  def self.INVESTOR_CATEGORIES(entity = nil)
    entity && entity.investor_categories.present? ? entity.investor_categories.split(",").map(&:strip) : INVESTOR_CATEGORIES
  end

  def self.INSTRUMENT_TYPES(entity = nil)
    entity && entity.instrument_types.present? ? entity.instrument_types.split(",").map(&:strip) : INSTRUMENT_TYPES
  end

  delegate :investor_entity_id, to: :investor

  def self.investments_for(current_user, entity)
    investments = Investment.none

    # Is this user from an investor
    investor = Investor.for(current_user, entity).first
    return investments unless investor

    # Get the investor access for this user and this entity
    access_right = AccessRight.investments.user_or_investor_access(current_user, investor).first

    if access_right.present?
      investments = entity.investments
                          .order(initial_value: :desc).
                    # joins(:investor, :investee_entity).
                    includes([investor: :investor_entity], :investee_entity)

      case access_right.metadata
      when AccessRight::ALL
        # Do nothing - we got all the investments
        logger.debug "Access to investor #{current_user.email} to ALL Entity #{entity.id} investments"
      when AccessRight::SELF
        # Got all the investments for this investor
        logger.debug "Access to investor #{current_user.email} to SELF Entity #{entity.id} investments"
        investments = investments.where(investor_id: investor.id)
      when InvestorAccess::SUMMARY
        # Show summary page
        logger.debug "Access to investor #{current_user.email} to SUMMARY Entity #{entity.id} investments"
      end
    else
      logger.debug "No access to investor #{current_user.email} to Entity #{entity.id} investments"
    end

    investments
  end
end
