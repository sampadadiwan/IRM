class SaveInvestment
  include Interactor::Organizer
  organize CreateAggregateInvestment, InvestmentSave, UpdateInvestorHoldings, UpdateInvestorCategory, CreateAuditTrail

  around do |organizer|
    ActiveRecord::Base.transaction do
      organizer.call
    end
  end
end
