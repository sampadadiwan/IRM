class Investor < ApplicationRecord
    has_paper_trail
    
    ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])
    
    belongs_to :investor_entity, foreign_key: "investor_entity_id", class_name: "Entity"
    belongs_to :investee_entity, foreign_key: "investee_entity_id", class_name: "Entity"    
    has_many :investor_accesses, dependent: :destroy

    delegate :name, to: :investee_entity, prefix: :investee

    INVESTOR_CATEGORIES = ENV["INVESTOR_CATEGORIES"].split(",") << "Prospective"

    def self.INVESTOR_CATEGORIES(entity=nil)
        Investment.INVESTOR_CATEGORIES(entity) << "Prospective"
    end
    
    scope :for_email,  ->(user) {
        where("investor_accesses.email": user.email).
            includes(:investor_accesses) 
    }

    scope :for_email_and_entity,  ->(user, investee_entity_id) { 
        where("investor_accesses.email": user.email).
        where("investors.investee_entity_id": investee_entity_id).
            joins(:investor_accesses).includes(:investor_accesses) 
    }

    before_save :update_name
    def update_name
        self.investor_name = self.investor_entity.name
    end
  

end
