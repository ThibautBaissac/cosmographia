class Admin::FeedbacksController < ApplicationController
 before_action :authorize_superadmin!

  def index
    feedbacks = Feedback.includes(:user).order(created_at: :desc)
    @pagy, @feedbacks = pagy(feedbacks)
  end

  def show
    @feedback = Feedback.find(params[:id])
  end

  private

  def authorize_superadmin!
    unless current_user.superadmin?
      redirect_to(root_path, alert: "You are not authorized to view this page.")
    end
  end
end
