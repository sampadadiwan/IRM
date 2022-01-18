# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.role == "Super"
      can :manage, :all
    elsif user.role == "User"
      can :read, Company
      can :read, Document, owner_type: "Company"
      can :manage, User, id: user.id
      can :manage, Document, owner_id: user.id
    else
      can :read, Company
    end

  end
end
