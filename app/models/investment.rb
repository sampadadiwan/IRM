class Investment < ApplicationRecord
    belongs_to :investor, polymorphic: true
    belongs_to :investee_company, foreign_key: "investee_company_id", class_name: "Company"    

    # "Series A,Series B,Series C"
    TYPES = ENV["INVESTMENT_TYPES"].split(",")

    # "Equity,Preferred,Debt,ESOPs"
    INSTRUMENTS = ENV["INVESTMENT_INSTRUMENTS"].split(",")
    
    STATUS_TYPES = ["Shareholder", "Prospective"]
    
    # "Lead Investor,Co-Investor,Founder,Individual,Employee"
    CATEGORIES = ENV["INVESTMENT_CATEGORIES"].split(",")

    scope :prospective, -> { where(investor_type: "Prospective") }
    scope :shareholders, -> { where(investor_type: "Shareholder") }

    after_create :create_investor

    def create_investor
        existing = self.investor_entity
        if (!existing.present?)
            Investor.create!(
                investor_id: self.investor_id, 
                investor_type: self.investor_type, 
                investee_company_id: self.investee_company_id,
                category: self.category
            )
        end
    end

    def investor_entity
        Investor.where(investor_id: self.investor_id, 
            investor_type: self.investor_type,
            investee_company_id: self.investee_company_id).first
    end

end
