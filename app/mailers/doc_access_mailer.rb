class DocAccessMailer < ApplicationMailer
  def notify_access
    ActiveStorage::Current.host = ENV['HOST']

    @doc_access = params[:doc_access]

    case @doc_access.access_type
    when "Email"
      to = @doc_access.to
    when "Category"
      # We need the email addresses of all investors in this category
      investors = @doc_access.document.owner.investors.where(category: @doc_access.to.strip)
      current_investor_ids = investors.collect(&:id)

      # Get the emails of the investors from investor access
      investor_emails = InvestorAccess.where(investor_id: current_investor_ids).collect(&:email)
      to = investor_emails.join(", ")
    end

    mail(to: to,
         cc: ENV['SUPPORT_EMAIL'],
         subject: "Document Access: #{@doc_access.document.name}")

    @doc_access.status = "Sent"
    @doc_access.save
  end
end
