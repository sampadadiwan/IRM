class Investor < ApplicationRecord
    has_paper_trail
    
    ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])
    
    belongs_to :investor_entity, foreign_key: "investor_entity_id", class_name: "Entity"
    belongs_to :investee_entity, foreign_key: "investee_entity_id", class_name: "Entity"    
    has_many :investor_accesses, dependent: :destroy
    has_many :access_rights, foreign_key: :access_to_investor_id, dependent: :destroy

    delegate :name, to: :investee_entity, prefix: :investee

    scope :for, -> (vc_user, startup_entity) { where(investee_entity_id: startup_entity.id, 
                                                     investor_entity_id: vc_user.entity_id) }
    
    scope :for_vc, -> (vc_user) { where(investor_entity_id: vc_user.entity_id) }
   
    INVESTOR_CATEGORIES = ENV["INVESTOR_CATEGORIES"].split(",") << "Prospective"

    def self.INVESTOR_CATEGORIES(entity=nil)
        Investment.INVESTOR_CATEGORIES(entity) << "Prospective"
    end
    
    before_save :update_name
    def update_name
        self.investor_name = self.investor_entity.name
    end

    

end
