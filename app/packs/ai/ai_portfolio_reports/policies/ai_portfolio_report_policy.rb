class AiPortfolioReportPolicy < ApplicationPolicy
  # Custom Scope that doesn't use entity_id
  class Scope < BaseScope
    def resolve
      # For now, return all reports
      # Later you can filter by analyst_id or other criteria
      scope.all

      # Or filter by current user:
      # scope.where(analyst_id: user.id)
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    true
  end

  def edit?
    update?
  end

  def destroy?
    true
  end

  def add_content?
    true
  end
end
