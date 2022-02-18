# == Schema Information
#
# Table name: deal_activities
#
#  id               :integer          not null, primary key
#  deal_id          :integer          not null
#  deal_investor_id :integer
#  by_date          :date
#  status           :string(20)
#  completed        :boolean
#  entity_id        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  title            :string(255)
#  details          :text(65535)
#  sequence         :integer
#  days             :integer
#  deleted_at       :datetime
#

class DealActivity < ApplicationRecord
  include PublicActivity::Model
  tracked except: :create, owner: proc { |controller, _model| controller.current_user if controller && controller.current_user },
          entity_id: proc { |controller, _model| controller.current_user.entity_id if controller && controller.current_user }
  has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy

  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  acts_as_list scope: %i[deal_id deal_investor_id], column: :sequence

  default_scope { order(sequence: :asc) }

  belongs_to :deal
  belongs_to :deal_investor, optional: true
  belongs_to :entity

  has_many :deal_docs, dependent: :destroy

  delegate :investor_name, to: :deal_investor, allow_nil: true
  delegate :name, to: :entity, prefix: :entity
  delegate :name, to: :deal, prefix: :deal

  has_rich_text :details

  scope :templates, ->(deal) { where(deal_id: deal.id).where(deal_investor_id: nil) }

  before_save :set_defaults

  def set_defaults
    self.status = "Template" if deal_investor_id.nil?
  end

  def completed_status
    completed ? "Yes" : "No"
  end

  def summary
    status.presence || completed_status
  end

  def to_s
    "#{title} : #{investor_name}"
  end
end
