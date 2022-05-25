class SaveInvestment
  include Interactor::Organizer
  organize CreateAggregateInvestment, InvestmentSave, UpdateInvestorHoldings, CreateAuditTrail
end
