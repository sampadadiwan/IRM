class Investment < ApplicationRecord
    ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])
    
    belongs_to :investor
    belongs_to :investee_entity, foreign_key: "investee_entity_id", class_name: "Entity"    

    # "Series A,Series B,Series C"
    TYPES = ENV["INVESTMENT_TYPES"].split(",")

    # "Equity,Preferred,Debt,ESOPs"
    INSTRUMENTS = ENV["INVESTMENT_INSTRUMENTS"].split(",")
    
    STATUS_TYPES = ["Shareholder", "Prospective"]
    
    # "Lead Investor,Co-Investor,Founder,Individual,Employee"
    CATEGORIES = ENV["INVESTMENT_CATEGORIES"].split(",")

    scope :prospective, -> { where(investor_type: "Prospective") }
    scope :shareholders, -> { where(investor_type: "Shareholder") }

    

    def investment_type_sq
        self.investment_type.delete(' ')
    end

    def accessible?(user)
        # Either investment belongs to the investor
        self.investor.investor_entity_id == user.entity_id ||
        # Or he is an investor in the entity
        user.investor_entity(self.investor.investee_entity_id).present?
    end

    def self.investments_for(current_user, entity)

        investments = []
        # Get the investor access for this user and this entity
        investor_access = InvestorAccess.user_access(current_user)
                                        .entity_access(entity.id).first
        
        if investor_access.present? 
            investments = entity.investments.
                order(initial_value: :desc).
                # joins(:investor, :investee_entity).
                includes([:investor=>:investor_entity], :investee_entity)

            case investor_access.access_type
                when InvestorAccess::ALL
                # Do nothing - we got all the investments
                logger.debug "Access to investor #{current_user.email} to ALL Entity #{entity.id} investments"
                when InvestorAccess::SELF
                # Got all the investments for this investor
                logger.debug "Access to investor #{current_user.email} to SELF Entity #{entity.id} investments"
                investments = investments.where(investor_id: investor_access.investor_id)
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
