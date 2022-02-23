class InterestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_cached_role?(:super)
        scope.all
      else
        scope.where("interest_entity_id=? or offer_entity_id=?", user.entity_id, user.entity_id)
      end
    end
  end

  def index?
    true
  end

  def show?
    user.has_cached_role?(:super) || (user.entity_id == record.interest_entity_id) ||
      (user.entity_id == record.offer_entity_id)
  end

  def create?
    show?
  end

  def new?
    user.id == record.user_id
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
