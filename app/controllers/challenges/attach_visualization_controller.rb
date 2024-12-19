class Challenges::AttachVisualizationController < ApplicationController
  before_action :set_challenge
  # before_action :set_authorize

  def new
  end

  def create
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:challenge_id])
  end

  def set_authorize
    authorize(@challenge)
  end
end
