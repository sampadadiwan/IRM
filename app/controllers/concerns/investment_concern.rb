module InvestmentConcern
  extend ActiveSupport::Concern

  def new_multi_investments(params, investment_params)
    investments = []

    params[:investment][:investment_instrument].each_with_index do |instrument, idx|
      quantity = params[:investment][:quantity][idx]
      price = params[:investment][:price][idx]
      liquidation_preference = params[:investment][:liquidation_preference][idx]

      next unless instrument.present? && quantity.present? && price.present?

      @investment = Investment.new(investment_params)
      @investment.investee_entity_id = current_user.entity_id
      @investment.currency = current_user.entity.currency
      @investment.scenario_id ||= @investment.actual_scenario.id

      @investment.investment_instrument = instrument
      @investment.quantity = quantity
      @investment.price = price
      @investment.liquidation_preference = liquidation_preference

      authorize @investment
      investments << @investment
    end

    investments
  end
end
