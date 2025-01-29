FactoryBot.define do
  factory :billing_plan_version, class: 'Billing::PlanVersion' do
    association :plan, factory: :billing_plan
    price_cents { 1000 }
    currency { "EUR" }
    monthly_visualization_limit { 100 }
    monthly_challenge_limit { 10 }
    sequence(:version_number) { |n| n }
    active { false }
    stripe_price_id { "price_#{SecureRandom.hex(10)}" }

    trait :active do
      active { true }
    end

    trait :inactive do
      active { false }
    end

    trait :free do
      price_cents { 0 }
      monthly_visualization_limit { 5 }
      monthly_challenge_limit { 1 }
      stripe_price_id { "price_free" }
      active { true }
    end
  end
end
