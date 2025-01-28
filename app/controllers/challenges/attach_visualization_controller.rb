class Challenges::AttachVisualizationController < ApplicationController
  before_action :set_challenge
  # before_action :set_authorize

  def new
    @visualizations = current_user.visualizations
                                  .where(challenge_id: nil)
                                  .includes(:image_attachment)
    @pagy, @visualizations = pagy(@visualizations, limit: 12)
  end

  def create
    redirect_to(participations_challenge_path(@challenge)) and return if params[:visualization_id].blank?

    visualization = current_user.visualizations.find(params[:visualization_id])
    if visualization.update(challenge_id: @challenge.id)
      flash[:notice] = t("challenge.attach_visualization.flash.actions.create.success")
    else
      flash[:alert] = t("challenge.attach_visualization.flash.actions.create.failure")
    end
    redirect_to(participations_challenge_path(@challenge))
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:challenge_id])
  end

  def set_authorize
    authorize(@challenge)
  end
end
