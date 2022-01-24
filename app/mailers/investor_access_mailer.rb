class InvestorAccessMailer < ApplicationMailer

    def notify_access
        @investor_access = params[:investor_access]
        mail(   to: @investor_access.email,
                cc: ENV['SUPPORT_EMAIL'],
                subject: "Investor Access: #{@investor_access.entity.name}")
    end


end
