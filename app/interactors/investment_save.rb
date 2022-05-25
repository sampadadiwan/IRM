class InvestmentSave
  include Interactor

  def call
    Rails.logger.debug "Interactor: InvestmentSave called"
    if context.investment
      investment = context.investment
      context.fail!(message: investment.errors.full_messages) unless investment.save
    else
      Rails.logger.debug "No investment specified"
      context.fail!(message: "No investment specified")
    end
  end
end
