class SaveInvestment
  include Interactor::Organizer
  organize CreateAggregateInvestment, InvestmentSave, UpdateInvestorHoldings, UpdateInvestorCategory, CreateAuditTrail

  before do |_organizer|
    context.audit_comment ||= "Save Investment"
  end

  around do |organizer|
    ActiveRecord::Base.transaction do
      organizer.call
    end
  end
end
