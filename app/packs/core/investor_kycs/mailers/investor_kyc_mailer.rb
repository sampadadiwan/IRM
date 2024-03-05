class InvestorKycMailer < ApplicationMailer
  helper ApplicationHelper
  helper CurrencyHelper

  before_action :set_kyc
  def set_kyc
    @investor_kyc = InvestorKyc.find(params[:investor_kyc_id])
    @custom_notification = @investor_kyc.entity.custom_notification(@notification.to_notification.email_method)
  end

  def notify_kyc_updated
    subject = "KYC updated for #{@investor_kyc.full_name}"
    send_mail(subject:)
  end

  def notify_kyc_verified
    subject = "Confirmation of your KYC: #{@investor_kyc.entity.name}"
    send_mail(subject:)
  end

  def notify_kyc_required
    subject = "Request to add KYC: #{@investor_kyc.entity.name}"
    send_mail(subject:)
  end

  def kyc_required_reminder
    subject = "Reminder to update KYC: #{@investor_kyc.entity.name}"
    send_mail(subject:)
  end
end
