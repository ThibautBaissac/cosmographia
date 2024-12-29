FactoryBot.define do
  factory :challenge_discussion, class: 'Challenge::Discussion' do
    content { "MyText" }
    challenge { nil }
    user { nil }
  end
end
