class ApproveOptionPool < Patterns::Service
  def initialize(option_pool)
    @option_pool = option_pool
  end

  def call
    OptionPool.transaction do
      option_pool.approved = true
      option_pool.save
      setup_trust_holdings
    end
    option_pool
  end

  private

  attr_reader :option_pool

  # The unallocated options sit in the trust account
  def setup_trust_holdings
    Rails.logger.debug "Option pool has been approved. Setting up trust holdings"
    trust_investor = option_pool.entity.investors.where(is_trust: true).first

    existing = Investment.where(funding_round_id: option_pool.funding_round_id, investor_id: trust_investor.id, investment_instrument: "Options").first

    if existing.present?
      existing.quantity = option_pool.number_of_options
      existing.save
    else

      investment = Investment.new(investee_entity_id: option_pool.entity_id,
                                  quantity: option_pool.number_of_options,
                                  price_cents: option_pool.excercise_price_cents,
                                  investment_instrument: "Options", investor_id: trust_investor.id,
                                  funding_round_id: option_pool.funding_round_id,
                                  scenario: option_pool.entity.actual_scenario)

      Rails.logger.debug "######Creating Investment for Trust Pool######"
      Rails.logger.debug investment.to_json

      SaveInvestment.call(investment)
      Rails.logger.debug investment.to_json

    end
  end
end
