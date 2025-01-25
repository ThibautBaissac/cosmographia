# frozen_string_literal: true

module User::Associations
  extend ActiveSupport::Concern

  included do
    has_many :visualizations, dependent: :destroy
    has_many :feedbacks, dependent: :destroy
    has_many :comments, class_name: "Visualization::Comment", dependent: :destroy
    has_many :user_softwares, dependent: :destroy
    has_many :softwares, through: :user_softwares
    has_many :user_challenges, dependent: :destroy
    has_many :challenges, through: :user_challenges
    has_many :dicussions, class_name: "Challenge::Discussion", dependent: :destroy

    accepts_nested_attributes_for :user_softwares, allow_destroy: true
  end
end
