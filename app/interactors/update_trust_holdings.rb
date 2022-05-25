class UpdateTrustHoldings
  include Interactor

  def call
    Rails.logger.debug "Interactor: UpdateTrustHoldings called"
    if context.holding.present?
      holding = context.holding
      update_trust_holdings(holding)
    else
      Rails.logger.debug "No Holding specified"
      context.fail!(message: "No Holding specified")
    end
  end

  def update_trust_holdings(holding)
    trust_investor = holding.entity.trust_investor
    if  holding.investment_instrument == 'Options' &&
        # This is a hack, when we update the trust investment -> Which updates the holdings -> We dont want it reducing the quantity here. I know I will forget this at sometime in the future.
        holding.investor_id != trust_investor.id &&
        holding.option_pool

      pool_investment = trust_investor.investments.where(funding_round_id: holding.option_pool.funding_round_id).first
      pool_investment.quantity -= holding.quantity
      pool_investment.save!
    end
  end
end
