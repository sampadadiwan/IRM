class InterestMailer < ApplicationMailer
  def notify_interest
    @interest = Interest.find params[:interest_id]
    emails = @interest.offer_entity.employees.collect(&:email)
    mail(to: emails,
         cc: ENV['SUPPORT_EMAIL'],
         subject: "New Interest for #{@interest.secondary_sale.name} ")
  end

  def notify_shortlist
    @interest = Interest.find params[:interest_id]
    emails = @interest.user.email
    mail(to: emails,
         cc: ENV['SUPPORT_EMAIL'],
         subject: "Interest Shortlisted for #{@interest.secondary_sale.name} ")

    msg = "Interest Shortlisted for #{@interest.secondary_sale.name} from #{@interest.secondary_sale.entity.name}. #{secondary_sale_url(@interest.secondary_sale)}"
    WhatsappSenderJob.new.perform(msg, @interest.user)
  end
end
