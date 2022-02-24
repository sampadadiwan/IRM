class SecondarySalePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_cached_role?(:super)
        scope.all
      elsif user.has_cached_role?(:secondary_buyer) || user.has_cached_role?(:investor)
        scope.where(visible_externally: true)
      else
        scope.where(entity_id: user.entity_id)
      end
    end
  end

  def index?
    true
  end

  def show_interest?
    (record.active? && user.has_cached_role?(:secondary_buyer) && record.visible_externally) ||
      (record.active? && user.has_cached_role?(:investor) && record.visible_externally)
  end

  def show?
    if user.has_cached_role?(:super) || (user.entity_id == record.entity_id)
      true
    else
      record.active? &&
        (user.has_cached_role?(:holding) ||
        ((user.has_cached_role?(:secondary_buyer) || user.has_cached_role?(:investor)) && record.visible_externally))
    end
  end

  def create?
    user.has_cached_role?(:super) || (user.entity_id == record.entity_id)
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def make_visible?
    update?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
