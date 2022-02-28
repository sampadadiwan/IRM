class HoldingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_cached_role?(:startup)
        scope.where("entity_id=?", user.entity_id)
      elsif user.has_cached_role?(:holding)
        scope.where("user_id=?", user.id)
      elsif user.has_cached_role?(:investor)
        scope.joins(:investor).where("investors.investor_entity_id=?", user.entity_id)
      end
    end
  end

  def index?
    true
  end

  def show?
    user.has_cached_role?(:super) ||
      (user.entity_id == record.entity_id && user.has_cached_role?(:startup)) ||
      (user.id == record.user_id && user.has_cached_role?(:holding)) ||
      (user.entity_id == record.investor.investor_entity_id && user.has_cached_role?(:investor))
  end

  def offer?
    (
      (user.id == record.user_id && user.has_cached_role?(:holding)) ||
      (user.entity_id == record.investor.investor_entity_id && user.has_cached_role?(:investor))
    )
  end

  def create?
    user.has_cached_role?(:super) || (user.entity_id == record.entity_id)
  end

  def new?
    create?
  end

  def update?
    create? && record.holding_type == "Employee" # Only employee holdings can be updated
  end

  def edit?
    create?
  end

  def destroy?
    create?
  end
end
