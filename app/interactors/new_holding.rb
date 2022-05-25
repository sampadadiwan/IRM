class NewHolding
  include Interactor

  def call
    Rails.logger.debug "Interactor: NewHolding called"
    if context.holding.present?
      holding = context.holding
      context.fail!(message: holding.errors.full_messages) unless holding.save
    else
      Rails.logger.debug "No Holding specified"
      context.fail!(message: "No Holding specified")
    end
  end
end
