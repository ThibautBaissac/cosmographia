class ChallengesController < ApplicationController
  before_action :build_challenge, only: [:new, :create]
  before_action :set_challenge, only: [:edit, :update, :destroy]
  before_action :authorize_resource, only: [:new, :create, :edit, :update, :destroy]

  def index
    challenges = Challenge.order(start_date: :desc)
    @pagy, @challenges = pagy(challenges)
  end

  def new
  end

  def create
    if @challenge.save
      redirect_to(participations_challenge_path(locale, @challenge),
                  notice: t("challenge.flash.actions.create.success"))
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @challenge.update(challenge_params)
      redirect_to(participations_challenge_path(locale, @challenge),
                  notice: t("challenge.flash.actions.update.success"))
    else
      render :edit
    end
  end

  def destroy
    @challenge.destroy
    redirect_to(challenges_path(locale), notice: t("challenge.flash.actions.destroy.success"))
  end

  private

  def build_challenge
    @challenge = if action_name == "create"
                   Challenge.new(challenge_params)
                 else
                   Challenge.new
                 end
  end

  def set_challenge
    @challenge = Challenge.find(params[:id])
  end

  def authorize_resource
    authorize(@challenge)
  end

  def challenge_params
    params.fetch(:challenge, {}).permit(:start_date, :end_date, :title, :description, :difficulty, :category)
  end
end
