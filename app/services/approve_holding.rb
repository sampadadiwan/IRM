class ApproveHolding
  include Interactor::Organizer
  organize HoldingApproved, SetupHoldingForInvestment, UpdateTrustHoldings, CreateAuditTrail

  around do |organizer|
    ActiveRecord::Base.transaction do
      organizer.call
    end
  end
end
