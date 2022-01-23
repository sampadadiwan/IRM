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
end
