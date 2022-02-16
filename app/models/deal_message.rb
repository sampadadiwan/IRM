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
#

class DealMessage < ApplicationRecord
  include Trackable

  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  belongs_to :user
  belongs_to :deal_investor
  has_rich_text :content

  scope :user_messages, lambda { |user|
                          where("deal_messages.user_id =? OR deal_investors.entity_id=? OR investors.investor_entity_id=?",
                                user.id, user.entity_id, user.entity_id).joins(deal_investor: [:investor]).includes(deal_investor: :investor)
                        }

  scope :tasks, -> { where(is_task: true) }
  scope :tasks_not_done, -> { where(is_task: true, task_done: false) }

  after_create_commit do
    broadcast_append_to "deal_investor_#{deal_investor_id}", target: "deal_investor_#{deal_investor_id}",
                                                             partial: "deal_messages/conversation_msg", locals: { msg: self }
  end

  def to_s
    deal_investor.investor_name
  end

  def unread(user); end
end
