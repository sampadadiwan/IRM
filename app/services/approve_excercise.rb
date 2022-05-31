class ApproveExcercise
  include Interactor::Organizer

  organize  ExcerciseApproved, NewHoldingFromExcercise,
            UpdateExistingHoldingPostExcercise, NotifyExcerciseApproval, CreateAuditTrail

  around do |organizer|
    ActiveRecord::Base.transaction do
      organizer.call
    end
  end
end
