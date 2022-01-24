class InvestorAccess < ApplicationRecord
    belongs_to :investor
    belongs_to :entity

    after_create :send_notification
    def send_notification
        InvestorAccessMailer.with(investor_access:self).notify_access.deliver_later
    end
end
