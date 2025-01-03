FactoryBot.define do
  factory :visualization_comment, class: 'Visualization::Comment' do
    association :user
    association :visualization
    content { Faker::Lorem.paragraph(sentence_count: 3) }
  end
end
