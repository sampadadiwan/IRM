class Investor < ApplicationRecord
    belongs_to :investor_company, foreign_key: "investor_company_id", class_name: "Company"
    belongs_to :investee_company, foreign_key: "investee_company_id", class_name: "Company"    
end
