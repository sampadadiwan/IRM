module ScenariosHelper
  def current_scenario(entity = nil)
    scenario_id = params[:scenario_id].presence || cookies[:scenario_id]
    scenario_id ||= entity.actual_scenario.id if entity&.actual_scenario
    cookies[:scenario_id] = scenario_id
    scenario_id
  end

  # # This is a critical helper method for Investment & AggregateInvestment to fuction properly
  # # It dictates which Investment and AI are shown based on the current_scenario
  # # Also any new Investment created are set to the current_scenario
  # def current_scenario(entity = nil)

  #   scenario_id = nil
  #   # Get it from params
  #   if params[:scenario_id].present?
  #     scenario_id = params[:scenario_id]
  #   elsif cookies[:scenario].present? && cookies[:scenario].split(":")[1].to_i == entity.id
  #     # Get it from cookie set below
  #     sne = cookies[:scenario].split(":")
  #     scenario_id = sne[0]
  #   else
  #     # Go to DB and get the Scenario
  #     scenario_id = entity.actual_scenario.id if entity&.actual_scenario
  #   end

  #   # Set the cookie
  #   cookies[:scenario] = "#{scenario_id}:#{entity.id}" if scenario_id
  #   scenario_id
  # end
end
