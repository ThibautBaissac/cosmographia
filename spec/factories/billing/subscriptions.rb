FactoryBot.define do
  factory :billing_subscription, class: 'Billing::Subscription' do
    association :user
    association :plan_version, factory: :billing_plan_version

    end_date { nil }
    status { "ACTIVE" }
    external_subscription_id { Faker::Alphanumeric.alphanumeric(number: 10).upcase }
    external_customer_id { Faker::Alphanumeric.alphanumeric(number: 10).upcase }

    trait :active do
      status { "ACTIVE" }
    end

    trait :cancelled do
      status { "CANCELLED" }
      end_date { Date.today }
    end

    trait :with_end_date do
      end_date { Date.today + 1.month }
    end
  end
end
