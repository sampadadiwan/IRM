class NotifyHoldingCancelled
  include Interactor

  def call
    Rails.logger.debug "Interactor: NotifyHoldingCancelled called"

    if context.holding.present?
      HoldingMailer.with(holding_id: context.holding.id).notify_cancellation.deliver_later
    else
      Rails.logger.debug "No Holding specified"
      context.fail!(message: "No Holding specified")
    end
  end
end
