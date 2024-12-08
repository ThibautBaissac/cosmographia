class Comment < ApplicationRecord
  belongs_to :visualization
  belongs_to :user

  validates :content, presence: true
end
