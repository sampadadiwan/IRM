class CancelHolding
  include Interactor::Organizer
  organize HoldingCancelled, NotifyHoldingCancelled, CreateAuditTrail

  around do |organizer|
    ActiveRecord::Base.transaction do
      organizer.call
    end
  end
end
