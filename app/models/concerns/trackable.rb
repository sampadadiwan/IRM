module Trackable
  extend ActiveSupport::Concern

  included do
    # Make all models versioned
    has_paper_trail

    # Soft delete for all models
    acts_as_paranoid

    # Make all models public activity
    include PublicActivity::Model
    tracked owner: proc { |controller, _model| controller.current_user if controller && controller.current_user }, entity_id: proc { |controller, _model| controller.current_user.entity_id if controller && controller.current_user }
    has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy
  end
end
