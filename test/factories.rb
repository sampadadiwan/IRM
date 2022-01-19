FactoryBot.define do
  factory :doc_visibility do
    document_id { 1 }
    visiblity_type { "MyString" }
    to { "MyString" }
  end

  factory :investor do
    investor_company_id { 1 }
    investee_company_id { 1 }
    category { "MyString" }
  end

  factory :investment do
    investment_type { Investment::TYPES[rand(Investment::TYPES.length)] }
    investor { Company.vcs.shuffle.first }
    investee_company_id { Company.startups.shuffle.first.id }
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
    company {Company.all.shuffle.first}
  end

  factory :company do
    name { Faker::Company.name }
    category { Faker::Company.industry }
    url { "https://#{Faker::Internet.domain_name}" }
    logo_url { Faker::Company.logo }
    details { Faker::Company.catch_phrase }
    founded { Date.today - 2.years - rand(10).months }
    funding_amount { rand(1..20) }
    funding_unit { "Million" }
    company_type { Company::TYPES[rand(Company::TYPES.length)]}
  end


end
