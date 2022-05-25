class UpdateExistingHoldingPostExcercise
  include Interactor

  def call
    Rails.logger.debug "Interactor: UpdateExistingHoldingPostExcercise called"

    if context.excercise.present?
      context.excercise.holding.reload.save
    else
      Rails.logger.debug "No Excercise specified"
      context.fail!(message: "No Excercise specified")
    end
  end
end
