class HoldingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.curr_role == "startup"
        scope.where("entity_id=?", user.entity_id)
      elsif user.curr_role == "holding"
        scope.where("user_id=?", user.id)
      elsif user.curr_role == "investor"
        scope.joins(:investor).where("investors.investor_entity_id=?", user.entity_id)
      end
    end
  end

  def index?
    user.entity.enable_holdings
  end

  def show?
    user.has_cached_role?(:super) ||
      (user.entity.enable_holdings && user.entity_id == record.entity_id && user.has_cached_role?(:startup)) ||
      (user.id == record.user_id && user.has_cached_role?(:holding)) ||
      (user.entity_id == record.investor.investor_entity_id && user.has_cached_role?(:investor))
  end

  def offer?
    (
      (user.id == record.user_id && user.has_cached_role?(:holding)) ||
      (user.entity_id == record.investor.investor_entity_id && user.has_cached_role?(:investor))
    )
  end

  def create?
    user.has_cached_role?(:super) || (user.entity_id == record.entity_id && user.entity.enable_holdings)
  end

  def new?
    create?
  end

  def update?
    # Only employee holdings can be and only if its not excercised
    create? &&
      record.holding_type != "Investor" &&
      record.excercised_quantity.zero? &&
      !record.cancelled
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def excercise?
    record.user_id == user.id
  end

  def cancel?
    create?
  end

  def esop_grant_letter?
    show? && record.investment_instrument == "Options"
  end
end
