class InvestorAccess < ApplicationRecord
  include Trackable

  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  validates :email, presence: true
  belongs_to :entity
  belongs_to :investor
  belongs_to :user, optional: true
  belongs_to :granter, class_name: "User", foreign_key: :granted_by, optional: true

  delegate :name, to: :entity, prefix: :entity
  delegate :investor_name, to: :investor

  scope :approved_for_user, lambda { |user|
    where("investor_accesses.user_id=? and investor_accesses.approved=?", user.id, true)
  }

  scope :approved_for, lambda { |user, entity|
                         where("investor_accesses.user_id=? and investor_accesses.entity_id=? and investor_accesses.approved=?", user.id, entity.id, true)
                       }

  before_save :update_user

  def update_user
    u = User.find_by(email: email)
    self.user = u if u
  end
end
