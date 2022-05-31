class ApproveOptionPool
  include Interactor::Organizer
  organize ApprovePool, SetupTrustHoldings, CreateAuditTrail


  around do |organizer|
    ActiveRecord::Base.transaction do
      organizer.call
    end
  end

end
