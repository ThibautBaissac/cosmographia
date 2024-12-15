class Admin::FeedbacksController < ApplicationController
  def index
    authorize([ :admin, :feedback ], :index?)
    feedbacks = Feedback.includes(:user).order(created_at: :desc)
    @pagy, @feedbacks = pagy(feedbacks)
  end
end
