class AccessRight < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :entity
  belongs_to :investor, foreign_key: :access_to_investor_id, optional: true

  scope :investments, -> { where(access_type: "Investment") }
  scope :documents, -> { where(access_type: "Document") }
  scope :deals, -> { where(access_type: "Deal") }

  def access_to_label
    self.access_to.present? ? self.access_to + " (Individual)" : self.investor.investor_name + " (Employees)"
  end

  after_create :send_notification, :update_user
  def send_notification
      if self.access_to =~ URI::MailTo::EMAIL_REGEXP
        AccessRightsMailer.with(access_right:self).notify_access.deliver_later
      end
  end

  def update_user
      u = User.where(email: self.access_to).first
      if u.present?
          u.is_investor = true
          u.save
      end
  end

end
