FactoryBot.define do
  factory :billing_plan, class: 'Billing::Plan' do
    sequence(:name) { |n| "Billing Plan #{n}" }
    description { "A description for the billing plan." }
    active { false }

    trait :active do
      active { true }
    end

    trait :free do
      active
      name { "Free" }
    end
  end
end
