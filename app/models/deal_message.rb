# == Schema Information
#
# Table name: deal_messages
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  deal_investor_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  is_task          :boolean          default("0")
#  task_done        :boolean          default("0")
#  deleted_at       :datetime
#  not_msg          :boolean          default("0")
#  entity_id        :integer          not null
#

class DealMessage < ApplicationRecord
  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  belongs_to :user
  belongs_to :entity
  counter_culture :entity, column_name: proc { |msg| msg.is_task && !msg.task_done ? 'tasks_count' : nil }

  belongs_to :deal_investor
  has_rich_text :content
  # encrypts :content
  validates :content, presence: true

  scope :user_messages, lambda { |user|
                          where("deal_messages.user_id =? OR deal_investors.entity_id=? OR investors.investor_entity_id=?",
                                user.id, user.entity_id, user.entity_id).joins(deal_investor: [:investor]).includes(deal_investor: :investor)
                        }

  scope :tasks, -> { where(is_task: true) }
  scope :not_msg, -> { where(not_msg: true) }
  scope :msg, -> { where(not_msg: false) }

  scope :tasks_not_done, -> { where(is_task: true, task_done: false) }

  after_create :broadcast_message, unless: :not_msg

  def broadcast_message
    broadcast_append_to "deal_investor_#{deal_investor_id}",
                        target: "deal_investor_#{deal_investor_id}",
                        partial: "deal_messages/conversation_msg", locals: { msg: self }
  end

  def to_s
    deal_investor.investor_name
  end

  def unread(user); end

  after_create :update_message_count
  def update_message_count
    if user.entity_id == deal_investor.entity_id
      deal_investor.unread_messages_investor += 1
      deal_investor.todays_messages_investor += 1
    else
      deal_investor.unread_messages_investee += 1
      deal_investor.todays_messages_investee += 1
    end

    deal_investor.save
  end
end
