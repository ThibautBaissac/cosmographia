class Admin::FeedbacksController < ApplicationController
  before_action :require_superadmin!

  def index
    feedbacks = Feedback.includes(:user).order(created_at: :desc)
    @pagy, @feedbacks = pagy(feedbacks)
  end
end
