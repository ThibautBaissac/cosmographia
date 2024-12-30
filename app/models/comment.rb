class Comment < ApplicationRecord
  include Mention::Mentionable

  belongs_to :visualization
  belongs_to :user

  validates :content, presence: true
end
