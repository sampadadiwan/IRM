FactoryBot.define do
  factory :excercise do
    entity { nil }
    holding { nil }
    user { nil }
    esop_pool { nil }
    quantity { 1 }
    price { "9.99" }
    amount { "9.99" }
    tax { "9.99" }
    approved { false }
  end


  factory :esop_pool do
    name { "Pool #{rand(10)}" }
    start_date { Date.today - rand(2).years - rand(12).months }
    number_of_options { 10000 * rand(1..5) }
    excercise_price_cents { 1000 * rand(1..10) }
    excercise_period_months { 12 * 10 }
  end

  factory :aggregate_investment do
    entity { nil }
    funding_round { nil }
    shareholder { "MyString" }
    investor { nil }
    equity { 1 }
    preferred { 1 }
    options { 1 }
    percentage { 1.5 }
    full_diluted_percentage { 1.5 }
  end

  factory :scenario do
    name { "MyString" }
    entity { nil }
  end

  factory :funding_round do
    name { "Series A,Series B,Series C,Series D,Series E,Series F".split(",")[rand(6)] + " - " + rand(5).to_s }
    total_amount_cents { rand(5..10) * 1000000 }
    pre_money_valuation_cents { rand(5..10) * 1000000 }
    entity { Entity.all.sample }
    currency { entity.currency }
  end

  factory :payment do
    entity { Entity.all.sample }
    amount { rand(100)*10 + rand(100) * 10 }
    plan { Entity::PLANS[rand(Entity::PLANS.length)] }
    discount { 0 }
    reference_number { (0...8).map { (65 + rand(26)).chr }.join }
    user { entity.employees.sample }
  end

  # factory :nudge do
  #   to { "MyText" }
  #   subject { "MyText" }
  #   msg_body { "MyText" }
  #   user { nil }
  #   entity { nil }
  #   item { nil }
  # end

  # factory :import_upload do
  #   name { "MyString" }
  #   entity { nil }
  #   owner { nil }
  #   user { nil }
  #   import_type { "MyString" }
  #   status { "MyString" }
  #   error_text { "MyText" }
  # end

  
  # factory :interest do
  # end

  
  factory :offer do
    PAN {(0...10).map { (65 + rand(26)).chr }.join} 
    address { Faker::Address.full_address }
    bank_account_number  {Faker::Bank.account_number}
    bank_name {Faker::Bank.name}
    bank_routing_info {Faker::Bank.routing_number}
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
  end

  factory :secondary_sale do
    name { "Sale-#{Time.zone.today}" }
    entity { nil }
    start_date { Time.zone.today }
    end_date { start_date + (2 + rand(10)).days }
    percent_allowed { (1 + rand(9)) * 10 }
    min_price { (1 + rand(9)) * 1000 }
    max_price { min_price + (1 + rand(9)) * 1000 }
    active { true }
  end

  factory :holding do
    user { User.all.sample }
    entity { Entity.all.sample }
    quantity { rand(10) * 10000 }
    price_cents { rand(3..10) * 10000 }
    holding_type { "Employee" }
    value_cents { quantity * price_cents }
  end

  factory :investor_access do
    investor_id { 1 }
    user_id { 1 }
    email { "MyString" }
    approved { false }
    granted_by { 1 }
    entity_id { 1 }
  end

  factory :document do
    name { "Fact Sheet,Cap Table,Latest Financials,Conversion Stats,Deal Sheet".split(",").sample }
    text { Faker::Company.catch_phrase }
    entity { Entity.all.sample }
    file { File.new("public/img/undraw_profile.svg", "r") }
    folder { Folder.first }
  end


  factory :deal_message do
    deal_investor { DealInvestor.all.sample }
    entity_id { deal_investor.entity_id}
    user { rand(2).positive? ? deal_investor.investor.investor_entity.employees.sample : deal_investor.investor.investee_entity.employees.sample }
    content { Faker::Company.catch_phrase }
    is_task { rand(2) }
    not_msg { rand(2) }
  end

  factory :deal_activity do
    title { Faker::Company.catch_phrase }
    details { Faker::Company.catch_phrase }
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
    primary_amount_cents { rand(3..11) * 100_000_000 }
    pre_money_valuation_cents { rand(3..11) * 100_000_000 }
    secondary_investment_cents { rand(3..11) * 100_000_000 }
    entity { deal.entity }
    company_advisor { Faker::Company.name }
    investor_advisor { Faker::Company.name }
  end

  factory :deal do
    entity { Entity.startups.all.sample }
    name { ["Series A", "Series B", "Series C", "Series D"][rand(4)] }
    amount { rand(2..10) * 10_000_000_000 }
    status { "Open" }
    currency { entity.currency }
    units { entity.units }
  end

  factory :note do
    investor { Investor.all.sample }
    details { 
      [
        "investor is keen on the space; have invested in peers globally",
        "investment size over $75m",
        "want to see positive cash flows ",
        "Meeting rescheduled 4 times; led by analyst and MD didn't show up",
        "Want to track company for 3-4 quarters before investing ",
        "Very keen on the space; have met all the peers and will come in for primary or secondary at short notice ",
        "Partner is alumni from business school and a techie at heart",
        "IC will focus on customer acquisition and market share gains over revenue / profitability ",
        "Sweet spot of $20-40million investment; this is a high conviction sector for them",
        "Arrogant investor; thinks we won't survive  ",
        "Invested in peers; probably fishing for information ",
        "High energy team; have offered to make introductions with the Silicon valley biggies for US roll-out"
      ].sample 
    }
    entity_id { investor.investee_entity_id }
    user { investor.investee_entity.employees.sample }
    on { Time.now - rand(120).days }
    created_at {Time.now - rand(120).days}
  end


  factory :investor do
    investor_entity_id { Entity.vcs.sample.id }
    investee_entity_id { Entity.startups.sample.id }
    category { ["Lead Investor", "Co-Investor"][rand(2)] }
  end

  factory :investment do
    # investee_entity_id { Entity.startups.sample.id }
    # investor { Investor.where(investee_entity_id: investee_entity_id).all.sample }
    investment_instrument { Investment::INSTRUMENT_TYPES[rand(Investment::INSTRUMENT_TYPES.length)] }
    category { ["Lead Investor", "Co-Investor"][rand(2)] }
    quantity { (rand(3..10) * 10000) }
    price { rand(3..10) * 1000}

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
    accept_terms {true}
  end

  factory :entity do
    name { Faker::Company.name }
    category { Faker::Company.industry }
    url { "https://#{Faker::Internet.domain_name}" }
    entity_type { Entity::TYPES[rand(Entity::TYPES.length)] }
    enable_documents {true}
    enable_deals {true}
    enable_investments {true}
    enable_holdings {true}
    enable_secondary_sale {true}
    currency { ENV["CURRENCY"].split(",")[rand(3)] }
    units { ENV["CURRENCY_UNITS"].split(",")[rand(3)] }

  end
end
