FactoryBot.define do
  factory :deal_message do
    user { nil }
    content { nil }
    deal_investor { nil }
  end

  factory :deal_activity do
    title { Faker::Company.catch_phrase }
    details { Faker::Quotes::Rajnikanth.joke }
    deal { Deal.all.shuffle.first }
    deal_investor { deal.deal_investors.shuffle.first }
    by_date { Date.today + rand(10).days }
    status {  }
    completed { [true, false][rand(2)] }
    entity_id { deal.entity_id }
  end

  factory :deal_investor do
    deal { Deal.all.shuffle.first }
    investor { deal.entity.investors.shuffle.first }
    status { DealInvestor::STATUS[ rand(DealInvestor::STATUS.length) ] }
    primary_amount { (rand(10) + 2) * 1000000 }
    secondary_investment { (rand(10) + 2) * 1000000 }
    entity { deal.entity }
  end


  factory :deal do
    entity { Entity.startups.all.shuffle.first }
    name { ["Series A", "Series B", "Series C", "Series D"][rand(4)] }
    amount { (rand(10) + 2) * 10000000 }
    status { "Open" }
  end

  factory :note do
    investor { Investor.all.shuffle.first }
    details { Faker::Quotes::Rajnikanth.joke }
    entity_id { investor.investee_entity_id }
    user { investor.investee_entity.employees.shuffle.first }
  end

  factory :investor_access do
    investor = Investor.all.shuffle.first
    investor_id { investor.id }
    entity_id { Entity.startups.all.shuffle.first.id }
    email { investor.investor_entity.employees.shuffle.first.email }
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
