class ApproveExcercise
  include Interactor::Organizer

  organize  ExcerciseApproved, NewHoldingFromExcercise,
            UpdateExistingHoldingPostExcercise, NotifyExcerciseApproval, CreateAuditTrail
end
