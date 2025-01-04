FactoryBot.define do
  factory :source do
    name { Faker::Company.name }
    url { Faker::Internet.url }
    description { Faker::Company.catch_phrase }
    location { Faker::Address.city }
  end
end
