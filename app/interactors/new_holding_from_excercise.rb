class NewHoldingFromExcercise
  include Interactor

  def call
    Rails.logger.debug "Interactor: NewHoldingFromExcercise called"

    if context.excercise.present?
      create_holding(context.excercise)
    else
      Rails.logger.debug "No Excercise specified"
      context.fail!(message: "No Excercise specified")
    end
  end

  def create_holding(excercise)
    # Generate the equity holding to update the cap table
    holding = Holding.new(user_id: excercise.user_id, entity_id: excercise.entity_id,
                          orig_grant_quantity: excercise.quantity, price_cents: excercise.price_cents,
                          investment_instrument: "Equity", investor_id: excercise.holding.investor_id,
                          holding_type: excercise.holding.holding_type,
                          funding_round_id: excercise.option_pool.funding_round_id,
                          employee_id: excercise.holding.employee_id, created_from_excercise_id: excercise.id)

    CreateHolding.call(holding:)
  end
end
