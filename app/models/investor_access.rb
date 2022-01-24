class InvestorAccess < ApplicationRecord
    belongs_to :investor
    belongs_to :entity

    has_one :investor_entity, through: :investor
    has_one :investee_entity, through: :investor

    after_create :send_notification
    def send_notification
        InvestorAccessMailer.with(investor_access:self).notify_access.deliver_later
    end
end
