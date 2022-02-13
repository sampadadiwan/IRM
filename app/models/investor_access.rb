class InvestorAccess < ApplicationRecord
  include Trackable

  belongs_to :entity
  belongs_to :investor
  belongs_to :user, optional: true
  belongs_to :granter, class_name: "User", foreign_key: :granted_by

  delegate :name, to: :entity, prefix: :entity
  delegate :investor_name, to: :investor

  scope :approved_for, lambda { |user, entity|
                         where("investor_accesses.user_id=? and investor_accesses.entity_id=? and investor_accesses.approved=?", user.id, entity.id, true)
                       }

  before_save :update_user

  def update_user
    u = User.find_by(email: email)
    self.user = u if u
  end
end
