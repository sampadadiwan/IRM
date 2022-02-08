FactoryBot.define do

  factory :deal_message do
    deal_investor { DealInvestor.all.sample }
    user { rand(2).positive? ? deal_investor.investor.investor_entity.employees.sample : deal_investor.investor.investee_entity.employees.sample }
    content { Faker::Quotes::Rajnikanth.joke }
  end

  factory :deal_activity do
    title { Faker::Company.catch_phrase }
    details { Faker::Quotes::Rajnikanth.joke }
    deal { Deal.all.sample }
    deal_investor { deal.deal_investors.sample }
    by_date { Date.today + rand(10).days }
    status {}
    completed { [true, false][rand(2)] }
    entity_id { deal.entity_id }
  end

  factory :deal_investor do
    deal { Deal.all.sample }
    investor { deal.entity.investors.sample }
    status { DealInvestor::STATUS[rand(DealInvestor::STATUS.length)] }
    primary_amount { rand(2..11) * 1_000_000 }
    secondary_investment { rand(2..11) * 1_000_000 }
    entity { deal.entity }
  end

  factory :deal do
    entity { Entity.startups.all.sample }
    name { ["Series A", "Series B", "Series C", "Series D"][rand(4)] }
    amount { rand(2..11) * 10_000_000 }
    status { "Open" }
  end

  factory :note do
    investor { Investor.all.sample }
    details { Faker::Quotes::Rajnikanth.joke }
    entity_id { investor.investee_entity_id }
    user { investor.investee_entity.employees.sample }
  end


  factory :investor do
    investor_entity_id { Entity.vcs.sample.id }
    investee_entity_id { Entity.startups.sample.id }
    category { Investment::INVESTOR_CATEGORIES[rand(Investment::INVESTOR_CATEGORIES.length)] }
  end

  factory :investment do
    investment_type { Investment::INVESTMENT_TYPES[rand(Investment::INVESTMENT_TYPES.length)] }
    investor { Investor.all.sample }
    investee_entity_id { Entity.startups.sample.id }
    investment_instrument { Investment::INSTRUMENT_TYPES[rand(Investment::INSTRUMENT_TYPES.length)] }
    category { Investment::INVESTOR_CATEGORIES[rand(Investment::INVESTOR_CATEGORIES.length)] }
    quantity { (rand(10) * 100) + (rand(10) * 10) }
    initial_value { quantity * rand(10) * 10 }
    current_value {}
  end

  factory :user do
    entity { Entity.all.sample }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email { entity ? "#{first_name.downcase}@#{entity.name.parameterize}.com" : Faker::Internet.email }
    password { "password" }
    phone { Faker::PhoneNumber.cell_phone }
    confirmed_at { Time.zone.now }
  end

  factory :entity do
    name { Faker::Company.name }
    category { Faker::Company.industry }
    url { "https://#{Faker::Internet.domain_name}" }
    entity_type { Entity::TYPES[rand(Entity::TYPES.length)] }
  end
end
