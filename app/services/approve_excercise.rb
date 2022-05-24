class ApproveExcercise < Patterns::Service
  def initialize(excercise)
    @excercise = excercise
  end

  def call
    Excercise.transaction do
      excercise.approved = true

      # Generate the equity holding to update the cap table
      holding = Holding.new(user_id: excercise.user_id, entity_id: excercise.entity_id,
                            orig_grant_quantity: excercise.quantity, price_cents: excercise.price_cents,
                            investment_instrument: "Equity", investor_id: excercise.holding.investor_id,
                            holding_type: excercise.holding.holding_type,
                            funding_round_id: excercise.option_pool.funding_round_id,
                            employee_id: excercise.holding.employee_id, created_from_excercise_id: excercise.id)

      CreateHolding.new(holding).call
      excercise.save!

      # Updates the existing Holding quantity
      excercise.holding.reload.save
    end
    ExcerciseMailer.with(excercise_id: excercise.id).notify_approval.deliver_later

    excercise
  end

  private

  attr_reader :excercise
end
