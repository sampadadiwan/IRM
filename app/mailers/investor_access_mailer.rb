class InvestorAccessMailer < ApplicationMailer
  def notify_access
    @investor_access = InvestorAccess.find params[:investor_access_id]
    mail(to: @investor_access.email,
         cc: ENV['SUPPORT_EMAIL'],
         subject: "Access Granted to #{@investor_access.entity_name} ")
  end
end
