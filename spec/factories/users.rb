# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "Password123!" }
    password_confirmation { "Password123!" }
    superadmin { false }
    locale { "en" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    bio { Faker::Lorem.paragraph }
    last_presence_at { Faker::Date.backward(days: 30) }
    personal_website { Faker::Internet.url }
    social_links { {twitter: Faker::Internet.url, linkedin: Faker::Internet.url} }
    guest { false }
    optin_directory { false }
    slug { "#{first_name}-#{last_name}-#{SecureRandom.hex(2)}" }
    public_profile { false }

    trait :superadmin do
      superadmin { true }
    end

    trait :guest do
      guest { true }
    end

    trait :public_profile do
      public_profile { true }
    end

    trait :optin_directory do
      optin_directory { true }
    end

    sequence(:slug) { |n| "user-#{n}" }
  end
end
