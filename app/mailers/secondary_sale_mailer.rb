class SecondarySaleMailer < ApplicationMailer
  helper InvestmentsHelper

  def notify_advisors
    @secondary_sale = SecondarySale.find(params[:id])

    # Should we send emails to all advisors ? Or all second
    sale_emails = User.joins(:entity).where('entities.entity_type in (?) or users.sale_notification=?',
                                            ["Advisor", "Family Office"], true).collect(&:email)

    mail(to: ENV['SUPPORT_EMAIL'],
         bcc: sale_emails.join(','),
         subject: "New Secondary Sale: #{@secondary_sale.name} by #{@secondary_sale.entity.name}")
  end

  def notify_open_for_offers
    @secondary_sale = SecondarySale.find(params[:id])

    # Get all emails of investors & holding company employees
    open_for_offers_emails = @secondary_sale.access_rights.collect(&:investor_emails).flatten +
                             @secondary_sale.access_rights.collect(&:holding_employees_emails).flatten

    mail(to: ENV['SUPPORT_EMAIL'],
         bcc: open_for_offers_emails.join(','),
         subject: "Secondary Sale: #{@secondary_sale.name} by #{@secondary_sale.entity.name}, open for offers")
  end
end
