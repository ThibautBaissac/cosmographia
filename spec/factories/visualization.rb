FactoryBot.define do
  factory :visualization do
    association :user
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    creation_date { Faker::Date.backward(days: 365) }
    scale { Faker::Number.between(from: 1, to: 100) }
    sources { Faker::Lorem.sentence(word_count: 5) }
    geographic_coverage { Visualization.geographic_coverage_values.sample }
    projection { Visualization.projection_values.sample }
    category { Visualization.category_values.sample }
    challenge { nil }

    after(:build) do |visualization|
      # Ensure you have a sample image at spec/fixtures/files/sample_image.png
      visualization.image.attach(
        io: File.open(Rails.root.join('db/seeds/images', "sample_1.png")),
        filename: 'sample_1.png',
        content_type: 'image/png'
      )
    end

    trait :with_challenge do
      association :challenge
    end

    trait :with_comments do
      after(:create) do |visualization|
        create_list(:visualization_comment, 3, visualization: visualization)
      end
    end

    trait :with_softwares do
      after(:create) do |visualization|
        # Assumes you have a Software factory defined
        create_list(:software, 2, visualizations: [visualization])
      end
    end
  end
end
