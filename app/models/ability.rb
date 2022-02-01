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
      can :investor_view, Entity.user_investor_entities(user) do |entity|
        user.investor_entity(entity.id).present?
      end
      can :manage, Entity, id: user.entity_id 
      
      can :manage, Deal, entity_id: user.entity_id 
      can :manage, DealInvestor, entity_id: user.entity_id       
      can :manage, DealActivity, entity_id: user.entity_id 
      
      can :manage, DealMessage, DealMessage.user_messages(user) do |msg| 
        msg.user_id == user.id ||
        msg.deal_investor.entity_id == user.entity_id ||
        msg.deal_investor.investor.investor_entity_id == user.entity_id          
      end

      can :manage, DealDoc, DealDoc.user_deal_docs(user) do |doc| 
        doc.user_id == user.id ||
        doc.deal.entity_id == user.entity_id ||
        (doc.deal_investor && 
          (doc.deal_investor.entity_id == user.entity_id ||
           doc.deal_investor.investor.investor_entity_id == user.entity_id)
        )          
      end


      can :show, Document do |doc|
        doc.accessible?(user) 
      end
      can :manage, Document, owner_type: "Entity", owner_id: user.entity_id
      
      can :read, User
      can :manage, User, entity_id: user.entity_id

      can :show, Investment do |inv|        
        inv.accessible?(user)
      end
      can :manage, Investment, investee_entity_id: user.entity_id
      
      can :manage, Investor, investee_entity_id: user.entity_id
      can :read, Note, entity_id: user.entity_id
      can :manage, Note, user_id: user.id

      can :manage, AccessRight, entity_id: user.entity_id
      can :manage, InvestorAccess #, investor: {investor_entity_id: user.entity_id}
      can :manage, DocAccess, entity_id: user.entity_id
    else
      can :read, Entity
      can :welcome, User
    end

  end
end
