class DocumentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role?(:super)
        scope.all
      else
        scope.where(owner_id: user.entity_id).where(owner_type: "Entity")
      end
    end
  end


  def index?
    true
  end

  def show?
    user.has_role?(:super) || (user.entity_id == record.owner_id && record.owner_type == "Entity")
  end

  def create?
    user.has_role?(:super) || (user.entity_id == record.owner_id && record.owner_type == "Entity")
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
