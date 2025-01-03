FactoryBot.define do
  factory :challenge do
    title { Faker::Lorem.sentence(word_count: 4) }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    start_date { Faker::Date.backward(days: 30) }
    end_date { Faker::Date.forward(days: 30) }
    difficulty { Challenge.difficulty_values.sample }
    category { Visualization.category_values.sample }

    # Traits for flexibility
    trait :with_users do
      after(:create) do |challenge|
        create_list(:user, 3, challenges: [challenge])
      end
    end

    trait :with_discussions do
      after(:create) do |challenge|
        create_list(:challenge_discussion, 2, challenge: challenge)
      end
    end

    trait :with_users_and_discussions do
      with_users
      with_discussions
    end
  end
end
