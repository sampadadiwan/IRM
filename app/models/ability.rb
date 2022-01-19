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
      can :manage, Company, id: user.company_id 
      can :manage, Document, owner_type: "Company", owner_id: user.company_id
      can :manage, User, company_id: user.company_id
      can :manage, Investment, investee_company_id: user.company_id
      can :read, Investor, investee_company_id: user.company_id
    elsif user.role == "Admin"
      can :manage, Company, id: user.company_id 
      can :manage, Document, owner_type: "Company", owner_id: user.company_id
      can :manage, User, company_id: user.company_id
      can :read, Investment, investee_company_id: user.company_id
      can :read, Investor, investee_company_id: user.company_id
    elsif user.role == "Employee"
      can :read, Company 
      can :show, Document do |doc|
        false
      end
      can :index, Document
      can :read, Investment, investor_company_id: user.company_id
      can :read, Investor, investor_company_id: user.company_id
    else
      can :read, Company
    end

  end
end
