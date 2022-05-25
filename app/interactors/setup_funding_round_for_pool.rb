class SetupFundingRoundForPool
  include Interactor

  def call
    Rails.logger.debug "Interactor: SetupFundingRoundForPool called"

    if context.option_pool.present?
      option_pool = context.option_pool
      option_pool.funding_round = FundingRound.create!(
        name: option_pool.name,
        currency: option_pool.entity.currency,
        entity_id: option_pool.entity_id,
        status: "Open"
      )
    else
      Rails.logger.error "No OptionPool specified"
      context.fail!(message: "No OptionPool specified")
    end
  end
end
