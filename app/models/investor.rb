class Investor < ApplicationRecord
    belongs_to :investor, polymorphic: true
    belongs_to :investee_company, foreign_key: "investee_company_id", class_name: "Company"    
end
