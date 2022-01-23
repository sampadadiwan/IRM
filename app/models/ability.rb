# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.role == "Super"
      can :manage, :all
    elsif user.role == "CxO"
      can :manage, Entity, id: user.entity_id 
      can :manage, Document, owner_type: "Entity", owner_id: user.entity_id
      can :manage, User, entity_id: user.entity_id
      can :manage, Investment, investee_entity_id: user.entity_id
      can :manage, Investor, investee_entity_id: user.entity_id
      can :manage, DocAccess do |dv|
        dv.owner && dv.owner.id == user.entity_id
      end
    elsif user.role == "Admin"
      can :manage, Entity, id: user.entity_id 
      can :manage, Document, owner_type: "Entity", owner_id: user.entity_id
      can :manage, User, entity_id: user.entity_id
      can :read, Investment, investee_entity_id: user.entity_id
      can :read, Investor, investee_entity_id: user.entity_id
      can :manage, DocAccess do |dv|
        dv.owner && dv.owner.id == user.entity_id
      end
    elsif user.role == "Employee"
      can :read, Entity 
      can :show, Document do |doc|
        false
      end
      can :index, Document
      can :read, Investment, investor_entity_id: user.entity_id
      can :read, Investor, investor_entity_id: user.entity_id
    else
      can :read, Entity
    end

  end
end
