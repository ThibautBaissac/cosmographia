class FeedbacksController < ApplicationController
  before_action :authenticate_user!

  def create
    @feedback = current_user.feedbacks.new(feedback_params)
    if @feedback.save
      redirect_to(root_path, notice: "Thank you for your feedback!")
    else
      redirect_to(root_path, alert: "Something went wrong. Please try again.")
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:subject, :message)
  end
end
