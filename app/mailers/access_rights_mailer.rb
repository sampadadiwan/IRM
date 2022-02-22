class AccessRightsMailer < ApplicationMailer
  def notify_access
    @access_right = AccessRight.find params[:access_right_id]

    # We need to figure out all the users impacted by this access right

    emails = @access_right.investor_emails

    if emails.present?
      mail(to: ENV['SUPPORT_EMAIL'],
           bcc: emails,
           cc: ENV['SUPPORT_EMAIL'],
           subject: "Access: #{@access_right.owner.name}")
    end
  end
end
