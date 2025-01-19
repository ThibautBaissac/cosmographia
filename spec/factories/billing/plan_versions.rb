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
  end
end
