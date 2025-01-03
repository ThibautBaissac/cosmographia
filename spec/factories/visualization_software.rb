FactoryBot.define do
  factory :visualization_software do
    association :software
    association :visualization
  end
end
