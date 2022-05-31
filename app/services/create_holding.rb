class CreateHolding
  include Interactor::Organizer
  organize UpdateHoldingValue, SetupHoldingForInvestment, UpdateTrustHoldings, NewHolding, CreateAuditTrail

  around do |organizer|
    ActiveRecord::Base.transaction do
      organizer.call
    end
  end
end
