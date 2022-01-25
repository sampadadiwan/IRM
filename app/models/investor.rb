class Investor < ApplicationRecord
    ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])
    
    belongs_to :investor_entity, foreign_key: "investor_entity_id", class_name: "Entity"
    belongs_to :investee_entity, foreign_key: "investee_entity_id", class_name: "Entity"    
    has_many :investor_accesses, dependent: :destroy

    delegate :name, to: :investor_entity, prefix: :investor
    delegate :name, to: :investee_entity, prefix: :investee

    CATEGORIES = ENV["INVESTMENT_CATEGORIES"].split(",") << "Prospective"
    
    scope :investors_for_email,  ->(user) { where("investor_accesses.email": user.email).includes(:investor_accesses) }
    scope :investors_for_email_and_entity,  ->(user, investee_entity_id) { 
        where("investor_accesses.email": user.email).
        where("investors.investee_entity_id": investee_entity_id).
                joins(:investor_accesses).includes(:investor_accesses) 
    }
  

end
