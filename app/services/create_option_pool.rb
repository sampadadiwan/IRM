class CreateOptionPool
  include Interactor::Organizer
  organize SetupFundingRoundForPool, CreatePool, CreateAuditTrail

  before do |_organizer|
    context.audit_comment = "Create Option Pool"
  end

  around do |organizer|
    ActiveRecord::Base.transaction do
      organizer.call
    end
  end
end
