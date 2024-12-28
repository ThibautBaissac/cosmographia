class Challenges::UserParticipationController < ApplicationController
  before_action :set_challenge
  before_action :set_authorize

  def create
    service = Challenge::JoinService.new(current_user, @challenge)
    if service.call.persisted?
      redirect_to(@challenge, notice: "Successfully joined the challenge.")
    else
      redirect_to(@challenge, alert: "Unable to join the challenge.")
    end
  end

  def destroy
    service = Challenge::LeaveService.new(current_user, @challenge)
    service.call
    redirect_to(@challenge, alert: "Successfully left the challenge.")
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:challenge_id])
  end

  def set_authorize
    authorize(@challenge, policy_class: Challenges::UserParticipationPolicy)
  end
end
