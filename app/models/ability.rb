# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.role == "Super"
      can :manage, :all
    elsif user.role == "Employee"
      can :investor_view, Entity do |entity|
        user.investor_entities.where("entities.id = ?", entity.id).first.present?
      end      
      can :manage, Entity, id: user.entity_id 
      
      can :show, Document do |doc|
        user.investor_entities.where("entities.id = ?", doc.owner_id).first.present?
      end
      can :manage, Document, owner_type: "Entity", owner_id: user.entity_id
      

      can :manage, User, entity_id: user.entity_id

      can :show, Investment do |inv|        
        inv.investor.investor_entity_id == user.entity_id ||
        user.investor_entities.where("entities.id = ?", inv.investor.investee_entity_id).first.present?
      end
      can :manage, Investment, investee_entity_id: user.entity_id
      
      can :manage, Investor, investee_entity_id: user.entity_id
      can :read, Note, entity_id: user.entity_id
      can :manage, Note, user_id: user.id

      can :manage, InvestorAccess #, investor: {investor_entity_id: user.entity_id}
      can :manage, DocAccess do |dv|
        dv.owner && dv.owner.id == user.entity_id
      end
    else
      can :read, Entity
    end

  end
end
