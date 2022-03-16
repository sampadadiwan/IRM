class Scenario < ApplicationRecord
  belongs_to :entity
  has_many :investments, dependent: :destroy

  def actual?
    name == "Actual"
  end
end
