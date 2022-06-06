class HoldingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      case user.curr_role
      when "startup"
        scope.where("entity_id=?", user.entity_id)
      when "holding"
        scope.approved.where("user_id=?", user.id)
      when "investor"
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
      record.investment_instrument != "Options" && (
        (user.id == record.user_id && user.has_cached_role?(:holding)) ||
        (user.entity_id == record.investor.investor_entity_id && user.has_cached_role?(:investor))
      )
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
      (record.excercised_quantity.zero? || record.manual_vesting) &&
      !record.cancelled
  end

  def edit?
    update? && (!record.approved || record.manual_vesting)
  end

  def destroy?
    false
  end

  def excercise?
    record.approved && record.user_id == user.id && record.investment_instrument == "Options" && record.net_avail_to_excercise_quantity.positive?
  end

  def cancel?
    create? && user.has_cached_role?(:approver) &&
      record.investment_instrument == "Options" &&
      record.quantity.positive? &&
      record.holding_type != "Investor"
  end

  def approve?
    create? && user.has_cached_role?(:approver) &&
      record.holding_type != "Investor"
  end

  def emp_ack?
    record.user_id == user.id && record.holding_type != "Investor"
  end

  def esop_grant_letter?
    show? && record.approved && record.emp_ack &&
      record.investment_instrument == "Options" && record.holding_type != "Investor"
  end
end
