class Investment < ApplicationRecord
    belongs_to :investor_company, foreign_key: "investor_company_id", class_name: "Company"
    belongs_to :investee_company, foreign_key: "investee_company_id", class_name: "Company"    

    TYPES = ENV["INVESTMENT_TYPES"].split(",")
    INSTRUMENTS = ENV["INVESTMENT_INSTRUMENTS"].split(",")
    INVESTOR_TYPES = ["Shareholder", "Prospective"]
    CATEGORIES = ENV["INVESTMENT_CATEGORIES"].split(",")

    scope :prospective, -> { where(investor_type: "Prospective") }
    scope :shareholders, -> { where(investor_type: "Shareholder") }

    after_create :create_investor

    def create_investor
        existing = self.investor
        if (!existing.present?)
            Investor.create(
                investor_company_id: self.investor_company_id, 
                investee_company_id: self.investee_company_id,
                category: self.category
            )
        end
    end

    def investor
        Investor.where(investor_company_id: self.investor_company_id, investee_company_id: self.investee_company_id).first
    end

end
