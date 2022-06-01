class HoldingMailer < ApplicationMailer
  helper InvestmentsHelper

  def notify_cancellation
    @holding = Holding.find params[:holding_id]
    emails = @holding.user.email

    @label = @holding.cancelled ? "Cancelled" : nil
    @label ||= @holding.lapsed ? "Lapsed" : "Updated"

    subject = "Your #{@holding.investment_instrument} has been #{@label}"
    mail(to: emails,
         cc: ENV['SUPPORT_EMAIL'],
         subject:)
  end

  def notify_approval
    @holding = Holding.find params[:holding_id]
    emails = @holding.user.email
    subject = "Your #{@holding.investment_instrument} has been approved"
    mail(to: emails,
         cc: ENV['SUPPORT_EMAIL'],
         subject:)
  end
end
