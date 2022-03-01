class Nudge < ApplicationRecord
  belongs_to :user
  belongs_to :entity
  belongs_to :item, polymorphic: true, optional: true
  has_many :access_rights, as: :owner, dependent: :destroy

  has_rich_text :msg_body
end
