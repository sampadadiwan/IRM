class SecondarySalePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_cached_role?(:super)
        scope.all
      elsif user.has_cached_role?(:startup)
        scope.where(entity_id: user.entity_id)
      elsif user.has_cached_role?(:holding) || user.has_cached_role?(:investor)
        scope.for(user)
      elsif user.has_cached_role?(:secondary_buyer)
        scope.where(visible_externally: true)
      else
        scope.nil
      end
    end
  end

  def index?
    user.entity.enable_secondary_sale
  end

  def offer?
    SecondarySale.for(user).present?
  end

  def show_interest?
    (record.active? && user.has_cached_role?(:secondary_buyer) && record.visible_externally)
  end

  def see_private_docs?
    user.entity_id == record.entity_id || user.entity.interests_shown.short_listed.where(secondary_sale_id: record.id).present?
  end

  def show?
    if user.has_cached_role?(:super) || (user.entity_id == record.entity_id && user.entity.enable_secondary_sale)
      true
    else
      record.active? &&
        (SecondarySale.for(user).present? ||
        (user.has_cached_role?(:secondary_buyer) && record.visible_externally))
    end
  end

  def create?
    user.has_cached_role?(:super) || (user.entity_id == record.entity_id && user.entity.enable_secondary_sale)
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
