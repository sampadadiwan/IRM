class EntityPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def dashboard?
    true
  end

  def search?
    true
  end

  def show?
    if user.entity_id == record.id
      true
    else
      user.entity_id != record.id
    end
  end

  def create?
    user.has_cached_role?(:super)
  end

  def new?
    update?
  end

  def update?
    user.entity_id == record.id
  end

  def edit?
    update?
  end

  def approve_all_holdings?
    update? && user.has_cached_role?(:approver)
  end

  def destroy?
    false
  end
end
