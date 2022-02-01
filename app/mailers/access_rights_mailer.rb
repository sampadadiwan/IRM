class AccessRightsMailer < ApplicationMailer

    def notify_access
        @access_right = params[:access_right]
        mail(   to: @access_right.access_to,
                cc: ENV['SUPPORT_EMAIL'],
                subject: "Access: #{@access_right.owner.name}")
    end


end
