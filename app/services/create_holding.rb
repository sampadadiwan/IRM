class CreateHolding < Patterns::Service
  def initialize(holding)
    @holding = holding
  end

  def call
    Holding.transaction do
      update_value
      setup_investment
      update_trust_holdings
      holding.save
    end
    holding
  end

  private

  attr_reader :holding

  def update_value
    if holding.option_pool
      holding.funding_round_id = holding.option_pool.funding_round_id
      holding.price_cents = holding.option_pool.excercise_price_cents
    end
    holding.quantity = holding.orig_grant_quantity
    holding.value_cents = holding.quantity * holding.price_cents
  end

  def update_trust_holdings
    trust_investor = holding.entity.trust_investor
    if  holding.investment_instrument == 'Options' &&
        # This is a hack, when we update the trust investment -> Which updates the holdings -> We dont want it reducing the quantity here. I know I will forget this at sometime in the future.
        holding.investor_id != trust_investor.id &&
        holding.option_pool

      pool_investment = trust_investor.investments.first
      pool_investment.quantity -= holding.quantity
      pool_investment.save!
    end
  end

  def setup_investment
    if Holding::INVESTMENT_FOR.include?(holding.holding_type)

      holding.investment = Investment.for(holding).first
      holding.funding_round_id = holding.option_pool.funding_round_id if holding.option_pool

      if holding.investment.nil?
        # Rails.logger.debug { "Updating investment for #{to_json}" }
        employee_investor = Investor.for(holding.user, holding.entity).first
        holding.investment = Investment.create!(investment_type: "#{holding.holding_type} Holdings",
                                                investment_instrument: holding.investment_instrument,
                                                category: holding.holding_type, investee_entity_id: holding.entity.id,
                                                investor_id: employee_investor.id, employee_holdings: true,
                                                quantity: 0, price_cents: holding.price_cents,
                                                currency: holding.entity.currency, funding_round: holding.funding_round,
                                                scenario: holding.entity.actual_scenario, notes: "Holdings Investment")

      end

    end

    holding.investment
  end
end
