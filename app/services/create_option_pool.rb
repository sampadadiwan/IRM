class CreateOptionPool
  include Interactor::Organizer
  organize SetupFundingRoundForPool, CreatePool, CreateAuditTrail
end
