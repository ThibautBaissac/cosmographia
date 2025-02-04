class FeedbacksController < ApplicationController
  before_action :authorize_resource, only: [ :create ]

  def create
    result = Feedback::CreationService.new(current_user, feedback_params).call

    if result.success?
      flash[:notice] = t("feedbacks.flash.actions.create.success")
    else
      flash[:alert] = t("feedbacks.flash.actions.create.failure")
    end
    redirect_to(root_path(locale))
  end

  private

  def authorize_resource
    authorize(Feedback, :create?)
  end

  def feedback_params
    params.require(:feedback).permit(:subject, :message)
  end
end
