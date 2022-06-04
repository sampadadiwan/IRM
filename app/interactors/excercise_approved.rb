class ExcerciseApproved
  include Interactor

  def call
    Rails.logger.debug "Interactor: ExcerciseApproved called"

    if context.excercise.present?
      excercise = context.excercise
      excercise.approved = true
      excercise.approved_on = Time.zone.today
      context.fail!(message: excercise.errors.full_messages) unless excercise.save
    else
      Rails.logger.debug "No Excercise specified"
      context.fail!(message: "No Excercise specified")
    end
  end

  def create_audit_trail(excercise)
    context.audit_trail ||= []
    context.parent_id ||= SecureRandom.uuid
    context.audit_trail << HoldingAuditTrail.new(action: :approve_excercise, owner: "Excercise", quantity: excercise.quantity, operation: :modify, ref: excercise, entity_id: excercise.entity_id, completed: true, parent_id: context.parent_id)
  end

  after do
    create_audit_trail(context.excercise)
  end
end
