class Note < ApplicationRecord

    ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

    has_rich_text :details
    belongs_to :entity
    belongs_to :user
    belongs_to :investor
end
