class Investor < ApplicationRecord
    ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])
    
    belongs_to :investor, polymorphic: true
    belongs_to :investee_company, foreign_key: "investee_company_id", class_name: "Company"    

    CATEGORIES = ENV["INVESTMENT_CATEGORIES"].split(",") << "Prospective"

end
