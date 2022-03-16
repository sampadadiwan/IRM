class Scenario < ApplicationRecord
  belongs_to :entity
  has_many :investments, dependent: :destroy

  def actual?
    name == "Actual"
  end

  def from(scenario)
    scenario.investments.each do |inv|
      new_inv = inv.dup
      new_inv.scenario = self
      new_inv.save
    end
  end
end
