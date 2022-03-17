module ScenariosHelper
  def current_scenario(entity = nil)
    scenario_id = params[:scenario_id].presence || cookies[:scenario_id]
    scenario_id ||= entity.actual_scenario.id if entity
    cookies[:scenario_id] = scenario_id
    scenario_id
  end
end
