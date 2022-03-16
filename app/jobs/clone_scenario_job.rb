class CloneScenarioJob < ApplicationJob
  queue_as :default

  def perform(scenario_id)
    scenario = Scenario.find(scenario_id)
    clone = Scenario.find(scenario.cloned_from)
    scenario.from(clone)
  end
end
