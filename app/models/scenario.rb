class Scenario < ApplicationRecord
  includes acts_as_paranoid

  belongs_to :entity
  has_many :investments, dependent: :destroy

  def actual?
    name == "Actual"
  end

  def from(scenario)
    Rails.logger.info "Cloning scenario #{scenario.name} investments into #{name}"
    scenario.investments.each do |inv|
      new_inv = inv.dup
      new_inv.scenario = self
      new_inv.aggregate_investment = nil
      new_inv.save!
    end
  end

  after_create ->(s) { CloneScenarioJob.perform_later(s.id) }, if: :cloned_from
end
