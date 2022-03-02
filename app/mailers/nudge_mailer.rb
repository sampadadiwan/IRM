class NudgeMailer < ApplicationMailer
  def send_nudge
    @nudge = Nudge.find(params[:id])

    mail(to: @nudge.to,
         cc: @nudge.cc,
         bcc: "#{ENV['SUPPORT_EMAIL']},#{@nudge.bcc}",
         subject: @nudge.subject)
  end
end
