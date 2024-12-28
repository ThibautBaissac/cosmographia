class Challenges::TabsController < ApplicationController
  before_action :set_challenge
  before_action :set_authorize

  def participations
    @visualizations = @challenge.visualizations.includes(:user, :image_attachment)
  end

  def discussion
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:id])
  end

  def set_authorize
    authorize(@challenge)
  end
end
