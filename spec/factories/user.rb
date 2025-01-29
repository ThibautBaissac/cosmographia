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
    public_profile { false }
    confirmation_token { nil }
    confirmed_at { DateTime.yesterday }
    confirmation_sent_at { nil }
    unconfirmed_email { nil }
    sequence(:slug) { |n| "user-#{n}" }

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

    trait :with_free_subscription do
      not_guest
      after(:create) do |user|
        plan = create(:billing_plan, :free)
        plan_version = create(:billing_plan_version, :free, billing_plan_id: plan.id)
        customer = Pay::Customer.create!(owner_type: "User",
                              owner_id: user.id,
                              processor: "stripe",
                              processor_id: SecureRandom.uuid,
                              default: true,
                              data: nil,
                              stripe_account: nil,
                              type: "Pay::Stripe::Customer")
        Pay::Subscription.create!(customer_id: customer.id,
                                  name: "Free",
                                  processor_id: "sub_00000",
                                  processor_plan: "price_00000",
                                  quantity: 1,
                                  status: "active",
                                  current_period_start: Time.current,
                                  current_period_end: Time.current + 1.month,
                                  trial_ends_at: nil,
                                  ends_at: nil,
                                  metered: false,
                                  pause_behavior: nil,
                                  pause_starts_at: nil,
                                  pause_resumes_at: nil,
                                  application_fee_percent: nil,
                                  metadata: {"plan_name" => "Free", "plan_version_id" => plan_version.id},
                                  data:
                                  {"subscription_items" => [ {"id" => "si_00000", "price" => {"id" => "price_00000", "type" => "recurring", "active" => true, "object" => "price", "created" => 1737968773, "product" => "prod_00000", "currency" => "eur", "livemode" => false, "metadata" => {}, "nickname" => nil, "recurring" => {"meter" => nil, "interval" => "month", "usage_type" => "licensed", "interval_count" => 1, "aggregate_usage" => nil, "trial_period_days" => nil}, "lookup_key" => nil, "tiers_mode" => nil, "unit_amount" => 0, "tax_behavior" => "unspecified", "billing_scheme" => "per_unit", "custom_unit_amount" => nil, "transform_quantity" => nil, "unit_amount_decimal" => "0"}, "metadata" => {}, "quantity" => 1} ]},
                                  stripe_account: nil,
                                  payment_method_id: nil,
                                  type: "Pay::Stripe::Subscription",
                                  prorate: true
        )
      end
    end
  end
end
