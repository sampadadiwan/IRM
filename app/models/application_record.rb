class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # Make all models public activity
  include PublicActivity::Model
  tracked
  tracked owner: proc { |controller, _model| controller.current_user if controller && controller.current_user }
  tracked entity_id: proc { |controller, _model| controller.current_user.entity_id if controller && controller.current_user }
  has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy

  # Make all models versioned
  has_paper_trail
end
