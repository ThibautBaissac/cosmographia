class Challenge::Discussion < ApplicationRecord
  include Mention::Mentionable

  belongs_to :challenge
  belongs_to :user

  validates :content, presence: true
end
