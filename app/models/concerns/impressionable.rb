module Impressionable
  extend ActiveSupport::Concern

  included do
    is_impressionable counter_cache: true, unique: :user_id

    def viewed_by
      ids = impressions.pluck(:user_id).uniq
      User.where(id: ids)
    end
  end
end
