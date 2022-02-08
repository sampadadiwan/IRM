# == Schema Information
#
# Table name: notes
#
#  id          :integer          not null, primary key
#  details     :text(65535)
#  entity_id   :integer
#  user_id     :integer
#  investor_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Note < ApplicationRecord
  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  has_rich_text :details
  belongs_to :entity
  belongs_to :user
  belongs_to :investor
end
