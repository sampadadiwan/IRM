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
    user.has_role?(:super) || (user.entity_id == record.deal_investor.entity_id)
  end

  def create?
    user.has_role?(:super) || (user.entity_id == record.deal_investor.entity_id)
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