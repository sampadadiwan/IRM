class OfferPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_cached_role?(:super)
        scope.all
      else
        scope.where(entity_id: user.entity_id)
      end
    end
  end

  def index?
    true
  end

  def show?
    if user.has_cached_role?(:super) || (user.entity_id == record.entity_id)
      true
    else
      record.holding.user_id == user.id && record.holding.entity_id == record.entity_id
    end
  end

  def create?
    if user.has_cached_role?(:super) || (user.entity_id == record.entity_id)
      true
    else
      record.holding.user_id == user.id && record.holding.entity_id == record.entity_id
    end
  end

  def approve?
    user.has_cached_role?(:super) || (user.entity_id == record.entity_id)
  end

  def new?
    create?
  end

  def update?
    user.id == record.user_id
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
