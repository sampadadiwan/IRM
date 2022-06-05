class CancelHolding
  include Interactor::Organizer
  organize HoldingCancelled, NotifyHoldingCancelled, CreateAuditTrail

  around do |organizer|
    ActiveRecord::Base.transaction do
      organizer.call
    end
  end

  after do
    # The trust must be updated only after the counter caches have updated the option pool
    context.holding.option_pool.reload
    UpdateTrustHoldings.call(holding: context.holding)
  end
end
