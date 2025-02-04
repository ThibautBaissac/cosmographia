class Challenges::UserParticipationController < ApplicationController
  before_action :set_challenge
  before_action :set_authorize

  def create
    service = Challenge::JoinService.new(current_user, @challenge)
    if service.call.persisted?
      redirect_to(@challenge, notice: t("challenge.user_participation.flash.actions.create.success"))
    else
      redirect_to(@challenge, alert: t("challenge.user_participation.flash.actions.create.failure"))
    end
  end


  def destroy
    service = Challenge::LeaveService.new(user: current_user, challenge: @challenge)
    service.call
    redirect_to(@challenge, alert: t("challenge.user_participation.flash.actions.destroy.success"))
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:challenge_id])
  end

  def set_authorize
    authorize(@challenge, policy_class: Challenges::UserParticipationPolicy)
  end
end
