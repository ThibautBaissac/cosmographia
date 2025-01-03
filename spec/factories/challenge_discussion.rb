FactoryBot.define do
  factory :challenge_discussion, class: 'Challenge::Discussion' do
    association :user
    association :challenge
    content { Faker::Lorem.paragraph(sentence_count: 3) }
  end
end
