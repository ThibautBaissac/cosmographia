FactoryBot.define do
  factory :feedback do
    association :user
    message { "This is a sample message." }
  end
end
