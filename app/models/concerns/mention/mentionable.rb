module Mention::Mentionable
  extend ActiveSupport::Concern

  included do
    before_save :extract_mentions
  end

  private

  def extract_mentions
    slugs = content.scan(Constants::Mention::REGEX).flatten.uniq
    user_ids = User.where(slug: slugs).pluck(:id)
    self.mentioned_user_ids = user_ids
  end
end
