class Task < ApplicationRecord
  update_index('task') { self if index_record? }
  include WithCustomField

  belongs_to :entity
  belongs_to :for_entity, class_name: "Entity", optional: true
  belongs_to :user
  belongs_to :assigned_to, class_name: "User", optional: true
  belongs_to :owner, polymorphic: true, optional: true

  has_many :noticed_events, as: :record, dependent: :destroy, class_name: "Noticed::Event"

  validates :details, presence: true, length: { maximum: 255 }
  validates :tags, length: { maximum: 50 }

  has_many :reminders, as: :owner, dependent: :destroy
  accepts_nested_attributes_for :reminders, allow_destroy: true

  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }

  # counter_culture :entity, column_name: proc { |t| t.completed ? nil : 'tasks_count' }

  # after_commit :send_notification, unless: :destroyed?
  def send_notification
    users = []
    users << user if response.blank?
    users << assigned_to if assigned_to
    users.uniq.each do |u|
      TaskNotifier.with(entity_id:, task: self).deliver_later(u)
    end
  end
end
