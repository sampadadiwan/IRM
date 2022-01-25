class InvestorAccess < ApplicationRecord
    belongs_to :investor
    belongs_to :entity

    has_one :investor_entity, through: :investor
    has_one :investee_entity, through: :investor

    ALL = "All Investments"
    SELF = "Self Investments"
    SUMMARY = "Summary Of Investments"
    VIEWS = [ALL, SELF, SUMMARY]

    scope :user_access,  ->(user) { where("investor_accesses.email": user.email) }
    scope :entity_access,  ->(entity_id) { where("investor_accesses.entity_id": entity_id) }


    after_create :send_notification, :update_user
    def send_notification
        InvestorAccessMailer.with(investor_access:self).notify_access.deliver_later
    end

    def update_user
        u = User.where(email: self.email).first
        if u.present?
            u.is_investor = true
            u.save
        end
    end
end
