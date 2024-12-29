class Comment < ApplicationRecord
  belongs_to :visualization
  belongs_to :user

  validates :content, presence: true

  before_save :extract_mentions

  private

  def extract_mentions
    slugs = content.scan(Constants::Mention::REGEX).flatten.uniq
    user_ids = User.where(slug: slugs).pluck(:id)
    self.mentioned_user_ids = user_ids
  end
end
