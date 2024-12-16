class Feedback < ApplicationRecord
  belongs_to :user

  validates :subject, :message, presence: true

  string_enum subject: Constants::Feedbacks::SUBJECTS
end
