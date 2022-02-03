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
    if user.has_role?(:super) || user.entity_id == record.id 
      true
    elsif user.entity_id != record.id  # Entity.for_investor(user).where("entities.id=?", record.id)
      true
    else
      false
    end
  end

  def create?
    user.has_role?(:super)
  end

  def new?
    update?
  end

  def update?
    user.has_role?(:super) || user.entity_id == record.id 
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

end
