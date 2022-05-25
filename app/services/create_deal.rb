class CreateDeal
  include Interactor::Organizer
  organize SetActiveDeal, CreateActivityTemplate
end
