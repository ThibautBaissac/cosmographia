class Challenges::AttachVisualizationController < ApplicationController
  before_action :set_challenge
  # before_action :set_authorize

  def new
    @visualizations = current_user.visualizations.where(challenge_id: nil).includes(:image_attachment)
  end

  def create
    visualization = current_user.visualizations.find(params[:visualization_id])
    visualization.update(challenge_id: @challenge.id)
    redirect_to(challenge_path(@challenge))
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:challenge_id])
  end

  def set_authorize
    authorize(@challenge)
  end
end
