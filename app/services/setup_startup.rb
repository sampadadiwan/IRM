class SetupStartup
  include Interactor::Organizer
  organize SetupFolders, SetupHoldingEntity

  around do |organizer|
    ActiveRecord::Base.transaction do
      organizer.call
    end
  end
end
