class ApproveOptionPool
  include Interactor::Organizer
  organize ApprovePool, SetupTrustHoldings, CreateAuditTrail
end
