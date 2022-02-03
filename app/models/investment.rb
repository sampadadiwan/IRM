class Investment < ApplicationRecord
    has_paper_trail
    
    ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])
    
    belongs_to :investor
    belongs_to :investee_entity, foreign_key: "investee_entity_id", class_name: "Entity"    

    # "Series A,Series B,Series C"
    INVESTMENT_TYPES = ENV["INVESTMENT_TYPES"].split(",")

    # "Equity,Preferred,Debt,ESOPs"
    INSTRUMENT_TYPES = ENV["INSTRUMENT_TYPES"].split(",")
    
    # "Lead Investor,Co-Investor,Founder,Individual,Employee"
    INVESTOR_CATEGORIES = ENV["INVESTOR_CATEGORIES"].split(",")

    scope :prospective, -> { where(investor_type: "Prospective") }
    scope :shareholders, -> { where(investor_type: "Shareholder") }

    # These functions override the defaults based on entities customization
    def self.INVESTMENT_TYPES(entity=nil)
        entity && entity.investment_types.present? ? entity.investment_types.split(",").map(&:strip) : INVESTMENT_TYPES 
    end
    def self.INVESTOR_CATEGORIES(entity=nil)
        entity && entity.investor_categories.present? ? entity.investor_categories.split(",").map(&:strip) : INVESTOR_CATEGORIES 
    end
    def self.INSTRUMENT_TYPES(entity=nil)
        entity && entity.instrument_types.present? ? entity.instrument_types.split(",").map(&:strip) : INSTRUMENT_TYPES 
    end


    def investment_type_sq
        self.investment_type.delete(' ')
    end

    def self.investments_for(current_user, entity)

        investments = Investment.none
        
        # Is this user from an investor
        investor = Investor.for(current_user, entity).first

        # Get the investor access for this user and this entity
        access_right = AccessRight.investments.user_or_investor_access(current_user, investor).first
        
        if access_right.present? 
            investments = entity.investments.
                order(initial_value: :desc).
                # joins(:investor, :investee_entity).
                includes([:investor=>:investor_entity], :investee_entity)

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
