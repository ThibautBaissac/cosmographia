class FeedbacksController < ApplicationController
  def create
    set_authorize
    @feedback = current_user.feedbacks.new(feedback_params)
    if @feedback.save
      redirect_to(root_path(locale),
                  notice: t("feedbacks.flash.actions.create.success"))
    else
      redirect_to(root_path(locale),
                  alert: t("feedbacks.flash.actions.create.failure"))
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
