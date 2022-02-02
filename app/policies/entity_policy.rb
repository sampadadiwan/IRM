class EntityPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role?(:super)
        scope.all
      else
        scope.all #where(id: user.entity_id)
      end
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
    user.has_role?(:super) || user.entity_id == record.id 
  end

  def create?
    show?
  end

  def new?
    show?
  end

  def update?
    show?
  end

  def edit?
    show?
  end

  def destroy?
    false
  end

end
