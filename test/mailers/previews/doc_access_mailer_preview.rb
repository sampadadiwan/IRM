# Preview all emails at http://localhost:3000/rails/mailers/doc_access_mailer
class DocAccessMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/doc_access_mailer/notify_access
  def notify_access
    DocAccessMailer.notify_access
  end

end
