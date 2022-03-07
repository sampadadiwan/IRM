class FolderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(entity_id: user.entity_id)
    end
  end

  def index?
    true
  end

  def show?
    user.has_cached_role?(:super) || user.entity_id == record.entity_id
  end

  def create?
    user.has_cached_role?(:super) || (user.entity_id == record.entity_id)
  end

  def new?
    create?
  end

  def update?
    create? && record.full_path != "/"
  end

  def edit?
    create? && record.full_path != "/"
  end

  def destroy?
    create? && record.full_path != "/"
  end
end
