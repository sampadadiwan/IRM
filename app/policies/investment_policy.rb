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
    user.has_role?(:super) || 
    # belongs to this users entity
    user.entity_id == record.investee_entity_id ||
    # Has been given :all_investment_access  
    user.has_role?(:all_investment_access, record.investee_entity) ||
    # or :some_investment_access and is the investor
    (user.has_role?(:some_investment_access, record.investee_entity) && record.investor.investor_entity_id == user.entity_id)
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
