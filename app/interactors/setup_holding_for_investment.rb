class SetupHoldingForInvestment
  include Interactor

  def call
    Rails.logger.debug "Interactor: SetupHoldingForInvestment called"
    if context.holding.present?
      holding = context.holding
      setup_investment(holding)
    else
      Rails.logger.error "No Holding specified"
      context.fail!(message: "No Holding specified")
    end
  end

  private

  def setup_investment(holding)
    Rails.logger.debug "Interactor: SetupHoldingForInvestment.setup_investment  called"

    if Holding::INVESTMENT_FOR.include?(holding.holding_type)

      holding.investment = Investment.for(holding).first
      holding.funding_round_id = holding.option_pool.funding_round_id if holding.option_pool

      if holding.investment.nil?
        # Rails.logger.debug { "Updating investment for #{to_json}" }
        employee_investor = Investor.for(holding.user, holding.entity).first
        investment = Investment.new(investment_type: "#{holding.holding_type} Holdings",
                                    investment_instrument: holding.investment_instrument,
                                    category: holding.holding_type, investee_entity_id: holding.entity.id,
                                    investor_id: employee_investor.id, employee_holdings: true,
                                    quantity: 0, price_cents: holding.price_cents,
                                    currency: holding.entity.currency, funding_round: holding.funding_round,
                                    scenario: holding.entity.actual_scenario, notes: "Holdings Investment")

        holding.investment = SaveInvestment.call(investment).result
      end

    end

    holding.investment
  end
end
