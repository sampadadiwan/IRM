class SaveInvestment < Patterns::Service
  def initialize(investment)
    @investment = investment
  end

  def call
    Investment.transaction do
      # First create the AggregateInvestment, otherwise the counter caches will not update it
      create_aggregate_investment
      investment.save!
      update_investor_holdings
      # end
    end
    investment
  end

  private

  attr_reader :investment

  # For Actual Scenario, for Investors (Not Employees or Founders), we want to create a holding
  # corresponding to this investment.
  # There will be only one such Holding per investment
  def update_investor_holdings
    if investment.scenario.actual? &&
       Investment::EQUITY_LIKE.include?(investment.investment_instrument) &&
       !investment.investor.is_holdings_entity

      holding = investment.holdings.first
      if holding
        # Since there is only 1 holding per Investor Investment
        # Just assign the quantityand price
        holding.orig_grant_quantity = investment.quantity
        holding.investment_instrument = investment.investment_instrument
        holding.price = investment.price
        holding.save!
      else
        holding = investment.holdings.build(entity: investment.investee_entity,
                                            investor_id: investment.investor_id,
                                            funding_round_id: investment.funding_round_id,
                                            option_pool: investment.funding_round.option_pool,
                                            grant_date: Time.zone.today,
                                            holding_type: "Investor",
                                            investment_instrument: investment.investment_instrument,
                                            orig_grant_quantity: investment.quantity,
                                            price: investment.price, value: investment.amount)

        CreateHolding.call(holding)
      end

    else
      # For Debt and other Non Equity - we dont need a holding
      Rails.logger.debug { "Not creating holdings for #{investment.to_json}" }
    end
  end

  def create_aggregate_investment
    if Investment::EQUITY_LIKE.include?(investment.investment_instrument)

      ai = AggregateInvestment.where(investor_id: investment.investor_id,
                                     entity_id: investment.investee_entity_id,
                                     scenario_id: investment.scenario_id).first

      investment.aggregate_investment = ai.presence ||
                                        AggregateInvestment.create!(investor_id: investment.investor_id,
                                                                   entity_id: investment.investee_entity_id,
                                                                   scenario_id: investment.scenario_id)

    end
  end
end
