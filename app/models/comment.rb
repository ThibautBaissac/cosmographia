class Comment < ApplicationRecord
  belongs_to :map
  belongs_to :user

  validates :content, presence: true
end
