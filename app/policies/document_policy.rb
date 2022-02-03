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
    elsif (user.entity_id == record.entity_id)
      true
    elsif  Document.where("documents.id=?", record.id).merge(AccessRight.for_access_type("Document")).
            merge(AccessRight.user_access(user)).
            joins(:access_rights).first.present? 

            true
    elsif  Document.where("documents.id=?", record.id).
            joins(:access_rights).
            merge(AccessRight.for_access_type("Document")).
            joins(:entity=>:investors).
            where("investors.investor_entity_id=?", user.entity_id).
            where("investors.category=access_rights.access_to_category").first.present?
          
            true
    else
      false
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
