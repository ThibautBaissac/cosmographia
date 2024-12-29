class ContentPresenter
  def initialize(content, current_user)
    @content = content
    @current_user = current_user
  end

  def with_mentions
    sanitized_content = sanitize(@content)
    highlighted_content = highlight_mentions(sanitized_content)
    highlighted_content.html_safe
  end

  private

  def highlight_mentions(content)
    content.gsub(Constants::Mention::REGEX) do |mention|
      mentioned_slug = $1
      render_mention(mentioned_slug) || mention
    end
  end

  def render_mention(mentioned_slug)
    user = User.find_by(slug: mentioned_slug)
    return unless user

    if user.id == @current_user.id
      "<span class='badge text-bg-primary'>@#{user.slug}</span>"
    else
      "<span class='text-primary'>@#{user.slug}</span>"
    end
  rescue ActiveRecord::RecordNotFound
    nil # Gracefully handle cases where a user lookup fails
  end

  def sanitize(content)
    ActionController::Base.helpers.sanitize(content)
  end
end
