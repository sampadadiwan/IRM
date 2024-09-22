class UserPolicy < ApplicationPolicy
  class Scope < BaseScope
    def resolve
      if user.curr_role.to_sym == :holding
        scope.where(id: user.id)
      else
        scope.where(entity_id: user.entity_id)
      end
    end
  end

  def index?
    !user.investor_advisor?
  end

  def welcome?
    true
  end

  def chat?
    user.enable_user_llm_chat
  end

  def show?
    user.id == record.id || (belongs_to_entity?(user, record) && user.has_cached_role?(:company_admin)) || support?
  end

  def create?
    (belongs_to_entity?(user, record) && user.has_cached_role?(:company_admin)) || support?
  end

  def new?
    user.has_cached_role?(:company_admin) || support?
  end

  def update?
    user.id == record.id ||
      create? || support?
  end

  def edit?
    update?
  end

  def destroy?
    # Only make user flag inactive, never destroy the user, else we loose associated data.
    false
  end
end
