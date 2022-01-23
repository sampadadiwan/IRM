class Investor < ApplicationRecord
    ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])
    
    belongs_to :investor_entity, foreign_key: "investor_id", class_name: "Entity"
    belongs_to :investee_entity, foreign_key: "investee_entity_id", class_name: "Entity"    

    CATEGORIES = ENV["INVESTMENT_CATEGORIES"].split(",") << "Prospective"
    
end
