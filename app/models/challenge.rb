class Challenge < ApplicationRecord
  include Challenge::Status

  has_many :user_challenges, dependent: :destroy
  has_many :users, through: :user_challenges
  has_many :visualizations, dependent: :nullify # We don't want to delete the visualizations when we delete a challenge
  has_many :discussions, class_name: 'Challenge::Discussion', dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :end_date, presence: true
  validates :difficulty, presence: true
  validate :end_date_after_start_date

  string_enum difficulty: Constants::Challenges::DIFFICULTY
  string_enum category: Constants::Visualizations::CATEGORY

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
