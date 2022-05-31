class CreateOptionPool
  include Interactor::Organizer
  organize SetupFundingRoundForPool, CreatePool, CreateAuditTrail

  around do |organizer|
    ActiveRecord::Base.transaction do
      organizer.call
    end
  end
end
