class VestingSchedule < ApplicationRecord
  belongs_to :esop_pool, optional: true
  belongs_to :entity

  before_validation :set_defaults

  def set_defaults
    self.entity_id = esop_pool.entity_id
  end
end
