class My::CommentsController < ApplicationController
  before_action :set_user
  before_action :set_authorize

  def show
    @total_comment_count = @user.comments.count
    @comments = @user.comments.includes(visualization: :image_attachment)
    @pagy, @comments = pagy(@comments, limit: 5)
  end

  private

  def set_user
    @user = current_user
  end

  def set_authorize
    authorize(@user, policy_class: My::CommentsPolicy)
  end
end
