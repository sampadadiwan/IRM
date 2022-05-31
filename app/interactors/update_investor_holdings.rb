class UpdateInvestorHoldings
  include Interactor

  def call
    Rails.logger.debug "Interactor: UpdateInvestorHoldings called"
    if context.investment
      update_investor_holdings(context.investment)
    else
      Rails.logger.debug "No investment specified"
      context.fail!(message: "No investment specified")
    end
  end

  # For Actual Scenario, for Investors (Not Employees or Founders), we want to create a holding
  # corresponding to this investment.
  # There will be only one such Holding per investment
  def update_investor_holdings(investment)
    Rails.logger.debug { "update_investor_holdings: investment.investor = #{investment.investor.investor_name}" }
    if investment.scenario.actual? && !investment.investor.is_holdings_entity &&
       Investment::EQUITY_LIKE.include?(investment.investment_instrument)

      holding = investment.holdings.first
      if holding
        # Since there is only 1 holding per Investor Investment
        # Just assign the quantityand price
        holding.orig_grant_quantity = investment.quantity
        holding.investment_instrument = investment.investment_instrument
        holding.price = investment.price
        holding.save!
      else
        holding = Holding.new(entity: investment.investee_entity, investment_id: investment.id,
                              investor_id: investment.investor_id, funding_round_id: investment.funding_round_id,
                              option_pool: investment.funding_round.option_pool,
                              grant_date: Time.zone.today, holding_type: "Investor",
                              investment_instrument: investment.investment_instrument,
                              orig_grant_quantity: investment.quantity,
                              price_cents: investment.price_cents, value_cents: investment.amount_cents, approved: true)

        CreateHolding.call(holding:)
      end

    else
      # For Debt and other Non Equity - we dont need a holding
      Rails.logger.debug { "Not creating holdings for #{investment.to_json}" }
    end
  end
end
