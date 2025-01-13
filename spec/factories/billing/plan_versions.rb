FactoryBot.define do
  factory :billing_plan_version, class: 'Billing::PlanVersion' do
    association :plan, factory: :billing_plan
    price_cents { 1000 }
    currency { "EUR" }
    monthly_visualization_limit { 100 }
    version_number { 1 }
    active { true }

    trait :inactive do
      active { false }
    end
  end
end
