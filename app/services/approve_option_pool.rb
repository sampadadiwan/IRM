class ApproveOptionPool
  include Interactor::Organizer
  organize ApprovePool, SetupTrustHoldings, CreateAuditTrail

  before do |_organizer|
    context.audit_comment = "Approve Option Pool"
  end

  around do |organizer|
    ActiveRecord::Base.transaction do
      organizer.call
    end
  end
end
