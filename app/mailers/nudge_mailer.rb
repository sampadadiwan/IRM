class NudgeMailer < ApplicationMailer
  def send_nudge
    @nudge = Nudge.find(params[:id])

    mail(to: @nudge.to,
         cc: ENV['SUPPORT_EMAIL'],
         subject: @nudge.subject)
  end
end
