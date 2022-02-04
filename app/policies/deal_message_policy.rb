class DealMessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role?(:super)
        scope.all
      else
        scope.where("deal_investors.entity_id": user.entity_id).joins(:deal_investor)
      end
    end
  end


  def index?
    true
  end

  def show?
    if user.has_role?(:super) || (user.entity_id == record.deal_investor.entity_id)
    elsif record.deal_investor && record.deal_investor.investor_entity_id == user.entity_id
      true
    else
      false
    end
  end

  def create?
    if user.has_role?(:super) || (user.entity_id == record.deal_investor.entity_id)
      true
    elsif record.deal_investor && record.deal_investor.investor_entity_id == user.entity_id
      true
    else
      false
    end
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