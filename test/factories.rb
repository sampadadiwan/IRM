FactoryBot.define do
  factory :note do
    details { "MyText" }
    entity_id { 1 }
    user { 1 }
    investor_id { 1 }
  end

  factory :investor_access do
    investor_id { Investor.all.shuffle.first.id }
    entity_id { Entity.startups.all.shuffle.first.id }
    email { User.all.shuffle.first.email }
    access_type { InvestorAccess::VIEWS[rand(InvestorAccess::VIEWS.length)] }
    granted_by { User.first }
  end

  factory :doc_access do
    document_id { 1 }
    visiblity_type { "MyString" }
    to { "MyString" }
  end

  factory :investor do
    investor_entity_id { Entity.vcs.shuffle.first.id }
    investee_entity_id { Entity.startups.shuffle.first.id }
    category { Investment::CATEGORIES[rand(Investment::CATEGORIES.length)] }
  end

  factory :investment do
    investment_type { Investment::TYPES[rand(Investment::TYPES.length)] }
    investor { Investor.all.shuffle.first }
    investee_entity_id { Entity.startups.shuffle.first.id }
    investment_instrument { Investment::INSTRUMENTS[rand(Investment::INSTRUMENTS.length)] }
    category { Investment::CATEGORIES[rand(Investment::CATEGORIES.length)] }
    quantity { rand(10) * 100 + rand(10) * 10 }
    initial_value { quantity * rand(10) * 10 }
    current_value {  }
  end

  
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { email }
    phone { Faker::PhoneNumber.cell_phone }
    role { User::ROLES[rand(User::ROLES.length)] }
    confirmed_at {Time.now}
    entity {Entity.all.shuffle.first}
  end

  factory :entity do
    name { Faker::Company.name }
    category { Faker::Company.industry }
    url { "https://#{Faker::Internet.domain_name}" }
    entity_type { Entity::TYPES[rand(Entity::TYPES.length)]}
  end


end
