class InvestmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role?(:super)
        scope.all
      else
        scope.where(investee_entity_id: user.entity_id)
      end
    end
  end


  def index?
    true
  end

  def show?
    if user.has_role?(:super) || user.entity_id == record.investee_entity_id ||
      # belongs to this users entity
      true
    end
    ar = AccessRight.for(record.investee_entity).for_access_type("Investment").user_access(user).first
    # User has been given :all_investment_access  
    if ar.present? 
      ar.metadata == "All" ? true : record.investor_entity_id == user.entity_id
    end

    investor = Investor.where(investor_entity_id: user.entity_id, investee_entity_id: record.entity_id).first
    ar = AccessRight.for(record.investee_entity).for_access_type("Investment")
    # Investor has been given access
    if investor.present? && ar.investor_access(investor).first.present?
      access = ar.investor_access(investor).first
      access.metadata == "All" ? true : record.investor_entity_id == user.entity_id
    end
  end

  def create?
    user.has_role?(:super) || user.entity_id == record.investee_entity_id 
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
    create?
  end

  def destroy?
    create?
  end

end
