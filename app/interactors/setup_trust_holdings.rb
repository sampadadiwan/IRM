class SetupTrustHoldings
  include Interactor

  def call
    Rails.logger.debug "Interactor: SetupTrustHoldings called"

    if context.option_pool.present?
      setup_trust_holdings(context.option_pool)
    else
      Rails.logger.debug "No OptionPool specified"
      context.fail!(message: "No OptionPool specified")
    end
  end

  # The unallocated options sit in the trust account
  def setup_trust_holdings(option_pool)
    Rails.logger.debug "Option pool has been approved. Setting up trust holdings"
    trust_investor = option_pool.entity.investors.where(is_trust: true).first

    existing = Investment.where(funding_round_id: option_pool.funding_round_id, investor_id: trust_investor.id, investment_instrument: "Options").first

    if existing.present?
      existing.quantity = option_pool.number_of_options
      existing.save
    else

      investment = Investment.new(investee_entity_id: option_pool.entity_id,
                                  category: "Trust",
                                  quantity: option_pool.number_of_options,
                                  price_cents: option_pool.excercise_price_cents,
                                  investment_instrument: "Options", investor_id: trust_investor.id,
                                  funding_round_id: option_pool.funding_round_id,
                                  scenario: option_pool.entity.actual_scenario)

      Rails.logger.debug "Creating Investment for Trust for Option Pool"
      SaveInvestment.call(investment)

    end
  end
end
