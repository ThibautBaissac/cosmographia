class PostComponent < ViewComponent::Base
  include Turbo::FramesHelper

  attr_reader :post, :edit_path, :destroy_partial, :locale, :current_user

  def initialize(post:, edit_path: nil, destroy_partial: nil, locale:, current_user:)
    @post = post
    @edit_path = edit_path
    @destroy_partial = destroy_partial
    @locale = locale
    @current_user = current_user
  end

  def editable?
    policy(post).edit? && edit_path.present?
  end

  def user_fullname
    post.user.fullname
  end

  def user_slug
    post.user.slug
  end

  def timestamp
    helpers.humanized_time_ago(post.created_at)
  end

  def post_content
    simple_format(ContentPresenter.new(post.content, current_user).with_mentions)
  end

  private

  def policy(record)
    Pundit.policy(current_user, record)
  end
end
