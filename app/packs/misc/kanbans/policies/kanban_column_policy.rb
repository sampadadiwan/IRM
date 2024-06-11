class KanbanColumnPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if %w[employee].include?(user.curr_role) # && user.has_cached_role?(:company_admin)
        scope.where(entity_id: user.entity_id)
      elsif user.entity_type == "Group Company"
        scope.where(entity_id: user.entity.child_ids)
      else
        scope.none
      end
    end
  end

  def index?
    permissioned_employee? && user.enable_kanban
  end

  def create?
    permissioned_employee? && user.enable_kanban
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def update_sequence?
    update?
  end

  def delete_column?
    permissioned_employee? && user.has_cached_role?(:company_admin)
  end

  def restore_column?
    permissioned_employee?
  end

  def permissioned_employee?
    if belongs_to_entity?(user, record)
      if user.has_cached_role?(:company_admin)
        true
      else
        %w[employee].include?(user.curr_role)
      end
    else
      false
    end
  end
end
