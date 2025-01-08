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
    personal_website { Faker::Internet.url }
    social_links { {github: Faker::Internet.url, linkedin: Faker::Internet.url} }
    guest { true }
    optin_directory { false }
    public_profile { false }
    confirmation_token { nil }
    confirmed_at { DateTime.yesterday }
    confirmation_sent_at { nil }
    unconfirmed_email { nil }

    trait :superadmin do
      superadmin { true }
    end

    trait :not_guest do
      guest { false }
    end

    trait :public_profile do
      public_profile { true }
    end

    trait :optin_directory do
      optin_directory { true }
    end

    trait :public_profile do
      public_profile { true }
    end

    sequence(:slug) { |n| "user-#{n}" }
  end
end
