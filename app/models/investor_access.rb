# == Schema Information
#
# Table name: investor_accesses
#
#  id          :integer          not null, primary key
#  investor_id :integer
#  user_id     :integer
#  email       :string(255)
#  approved    :boolean
#  granted_by  :integer
#  entity_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  deleted_at  :datetime
#

class InvestorAccess < ApplicationRecord
  include Trackable

  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  validates :email, presence: true
  belongs_to :entity
  belongs_to :investor
  counter_culture :investor, column_name: proc { |model| model.approved ? 'investor_access_count' : 'unapproved_investor_access_count' }

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
    self.email = email.strip
    u = User.find_by(email: email)
    self.user = u if u
  end

  before_save :send_notification
  def send_notification
    InvestorAccessMailer.with(investor_access_id: id).notify_access.deliver_later if approved && approved_changed? && URI::MailTo::EMAIL_REGEXP.match?(email)
  end
end
