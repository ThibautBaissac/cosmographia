FactoryBot.define do
  factory :feedback do
    association :user
    subject { Feedback.subject_values.sample }
    message { "This is a sample message." }
  end
end
