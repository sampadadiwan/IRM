class CreateDeal
  include Interactor::Organizer
  organize SetActiveDeal, CreateActivityTemplate

  around do |organizer|
    ActiveRecord::Base.transaction do
      organizer.call
    end
  end
end
