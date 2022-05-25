class SaveInvestment
  include Interactor::Organizer
  organize CreateAggregateInvestment, InvestmentSave, UpdateInvestorHoldings
end
