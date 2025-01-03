FactoryBot.define do
  factory :software do
    sequence(:name) { |n| "Software_#{n}" }
    category { "GIS" }
  end
end
