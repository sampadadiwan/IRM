class InvestmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role?(:super)
        scope.all
      else
        scope.where(investee_entity_id: user.entity_id)
      end
    end
  end


  def index?
    true
  end

  def show?

    allow = false
    if user.has_role?(:super) || user.entity_id == record.investee_entity_id
      # belongs to this users entity
      return true
    else
      Rails.logger.debug "#{user.email} is not super for #{record.id}"
      ar = AccessRight.for(record.investee_entity).for_access_type("Investment").user_access(user).first
      # User has been given individual access  
      if ar.present? 
        Rails.logger.debug "#{user.email} direct access #{ar.to_json} for #{record.id}"
        return (ar.metadata == "All" ? true : record.investor.investor_entity_id == user.entity_id)
      else
        Rails.logger.debug "#{user.email} no direct access #{ar.to_json} for #{record.id}"
        investor = Investor.where(investor_entity_id: user.entity_id, investee_entity_id: record.investee_entity_id).first
        ar = AccessRight.for(record.investee_entity).for_access_type("Investment")
        # Investor has been given access
        if investor.present? && ar.investor_access(investor).first.present?
          access = ar.investor_access(investor).first
          return (access.metadata == "All" ? true : record.investor_entity_id == user.entity_id)
        else
          Rails.logger.debug "#{user.email} no category access #{ar.to_json} #{investor} for #{record.id}"
        end
      end      
    end

    allow

  end

  def create?
    user.has_role?(:super) || user.entity_id == record.investee_entity_id 
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
