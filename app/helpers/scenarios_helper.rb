module ScenariosHelper
  def current_scenario(entity = nil)
    scenario_id = params[:scenario_id].presence || cookies[:scenario_id]
    scenario_id ||= entity.actual_scenario.id if entity&.actual_scenario
    cookies[:scenario_id] = scenario_id
    scenario_id
  end

  def clear_current_scenario
    cookies.delete :scenario_id
  end

  def calculate_scenario(scenario, params)
    total_stake = params[:pre_money_valuation].to_f + params[:amount].to_f
    stake = total_stake.positive? ? (params[:amount].to_f / total_stake) : 0

    aggregate_investments = []
    ai = Struct.new(:investor_name, :percentage, :full_diluted_percentage)

    scenario.aggregate_investments.includes(:investor).each do |aggregate_investment|
      new_ai = ai.new(aggregate_investment.investor_name, aggregate_investment.percentage * (1 - stake).round(2), aggregate_investment.full_diluted_percentage * (1 - stake).round(2))

      aggregate_investments << new_ai
    end

    aggregate_investments << ai.new("NewInvestor", (stake * 100).round(2), (stake * 100).round(2))

    [(stake * 100).round(2), aggregate_investments]
  end
end
