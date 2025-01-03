FactoryBot.define do
  factory :comment, class: 'Visualization::Comment' do
    association :visualization
    association :user
    content { "This is a sample comment." }
    mentioned_user_ids { [] }
  end
end
