class CreateHolding
  include Interactor::Organizer
  organize UpdateHoldingValue, NewHolding, CreateAuditTrail

  before do |_organizer|
    context.audit_comment ||= "Create Holding"
  end

  around do |organizer|
    ActiveRecord::Base.transaction do
      organizer.call
    end
  end
end
