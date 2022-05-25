class CreateAuditTrail
  include Interactor

  def call
    Rails.logger.debug "Interactor: CreateAuditTrail called"
    if context.audit_trail
      Rails.logger.debug { "Audit Trail: #{context.audit_trail}" }
      if context.audit_trail.length.positive?
        attributes_array = context.audit_trail.map(&:attributes)
        HoldingAuditTrail.insert_all(attributes_array)
      end
    else
      Rails.logger.debug "No Audit Trail specified"
      context.fail!(message: "No Audit Trail specified")
    end
  end
end
