class My::MentionsController < ApplicationController
  # before_action :set_authorize

  def index
    @posts = combined_posts
  end

  private

  def comments
    Visualization::Comment.where("mentioned_user_ids @> ?", [ current_user.id ].to_json)
           .includes(:user, :visualization)
           .order(created_at: :desc)
           .limit(10)
  end

  def discussions
    Challenge::Discussion.where("mentioned_user_ids @> ?", [ current_user.id ].to_json)
                         .includes(:user, :challenge)
                         .order(created_at: :desc)
                         .limit(10)
  end

  def combined_posts
    (comments + discussions).sort_by(&:created_at).reverse
  end

  def set_authorize
    authorize(current_user)
  end
end
