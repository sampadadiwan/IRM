FactoryBot.define do
  
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { email }
    phone { Faker::PhoneNumber.cell_phone }
    role { User::ROLES[rand(User::ROLES.length)] }
    confirmed_at {Time.now}
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
