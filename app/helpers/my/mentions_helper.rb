
module My::MentionsHelper
  def determine_post_url(post)
    if post.is_a?(Comment)
      visualization_path(post.visualization)
    elsif post.is_a?(Challenge::Discussion)
      discussion_challenge_path(post.challenge)
    end
  end
end
