class CreateHolding
  include Interactor::Organizer

  organize UpdateHoldingValue, SetupHoldingForInvestment, UpdateTrustHoldings, NewHolding, CreateAuditTrail
end
