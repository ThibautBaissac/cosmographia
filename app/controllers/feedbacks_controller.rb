class FeedbacksController < ApplicationController
  def create
    set_authorize
    @feedback = current_user.feedbacks.new(feedback_params)
    if @feedback.save
      redirect_to(root_path(locale), notice: "Thank you for your feedback!")
    else
      redirect_to(root_path(locale), alert: "Something went wrong. Please try again.")
    end
  end

  private

  def set_authorize
    authorize(Feedback, :create?)
  end

  def feedback_params
    params.require(:feedback).permit(:subject, :message)
  end
end
