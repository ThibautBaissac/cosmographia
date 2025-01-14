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
    country_code { ISO3166::Country.all.sample.alpha2 }
    bio { Faker::Lorem.paragraph }
    personal_website { Faker::Internet.url }
    social_links { {github: Faker::Internet.url, linkedin: Faker::Internet.url} }
    optin_directory { false }
    public_profile { false }
    confirmation_token { nil }
    confirmed_at { DateTime.yesterday }
    confirmation_sent_at { nil }
    unconfirmed_email { nil }

    trait :superadmin do
      superadmin { true }
    end

    trait :guest do
      first_name { nil }
      last_name { nil }
      country_code { nil }
    end

    trait :not_guest do
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.last_name }
      country_code { ISO3166::Country.all.sample.alpha2 }
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

    trait :with_remaining_visualizations do
      not_guest
      after(:create) do |user|
        create(:billing_plan)
        billing_plan_version = create(:billing_plan_version)
        create(:billing_subscription, user: user, plan_version: billing_plan_version)
      end
    end

    sequence(:slug) { |n| "user-#{n}" }
  end
end
