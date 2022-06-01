class ApproveHolding
  include Interactor::Organizer
  organize HoldingApproved, SetupHoldingForInvestment, UpdateTrustHoldings, NotifyHoldingApproval, CreateAuditTrail

  around do |organizer|
    ActiveRecord::Base.transaction do
      organizer.call
    end
  end
end
