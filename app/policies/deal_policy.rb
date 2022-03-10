class DealPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_cached_role?(:super)
        scope.all
      elsif user.has_cached_role?(:startup)
        scope.where(entity_id: user.entity_id)
      elsif user.has_cached_role?(:investor)
        Deal.for_investor(user)
      end
    end
  end

  def index?
    user.entity.enable_deals
  end

  def show?
    if user.has_cached_role?(:super) || (user.entity_id == record.entity_id && user.entity.enable_deals)
      true
    else
      user.entity.enable_deals &&
        Deal.for_investor(user).where("deals.id=?", record.id).first.present?
    end
  end

  def create?
    user.has_cached_role?(:super) || (user.entity_id == record.entity_id && user.entity.enable_deals)
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def start_deal?
    update?
  end

  def edit?
    create?
  end

  def destroy?
    create?
  end
end
