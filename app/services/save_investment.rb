class SaveInvestment < Patterns::Service
  def initialize(investment, parent_audit_trail = nil)
    @investment = investment
    @parent_audit_trail = parent_audit_trail
  end

  def call
    Rails.logger.debug "Service: SaveInvestment called"

    Investment.transaction do
      # First create the AggregateInvestment, otherwise the counter caches will not update it
      create_aggregate_investment
      investment.save
      update_investor_holdings
      # end
    end
    investment
  end

  private

  attr_reader :investment, :parent_audit_trail, :audit_trail

  def save_investment; end

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
        holding = Holding.new(entity: investment.investee_entity,
                              investment_id: investment.id,
                              investor_id: investment.investor_id,
                              funding_round_id: investment.funding_round_id,
                              option_pool: investment.funding_round.option_pool,
                              grant_date: Time.zone.today,
                              holding_type: "Investor",
                              investment_instrument: investment.investment_instrument,
                              orig_grant_quantity: investment.quantity,
                              price_cents: investment.price_cents, value_cents: investment.amount_cents)

        CreateHolding.call(holding:)
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
