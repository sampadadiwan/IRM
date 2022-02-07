class DocumentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role?(:super)
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
    if user.has_role?(:super)
      true
    elsif user.entity_id == record.entity_id
      true
    else
      Document.for_investor(user, record.entity)
              .where("documents.id=?", record.id).first.present?
    end
  end

  def create?
    user.has_role?(:super) || (user.entity_id == record.entity_id)
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
