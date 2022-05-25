class ExcerciseApproved
  include Interactor

  def call
    Rails.logger.debug "Interactor: ExcerciseApproved called"

    if context.excercise.present?
      excercise = context.excercise
      excercise.approved = true
      context.fail!(message: excercise.errors.full_messages) unless excercise.save
    else
      Rails.logger.debug "No Excercise specified"
      context.fail!(message: "No Excercise specified")
    end
  end
end
