class ChallengesController < ApplicationController
  before_action :set_challenge, only: [ :edit, :update, :destroy ]

  def index
    challenges = Challenge.all.order(start_date: :desc)
    @pagy, @challenges = pagy(challenges)
  end

  def new
    @challenge = Challenge.new
    set_authorize
  end

  def create
    @challenge = Challenge.new(challenge_params)
    set_authorize
    if @challenge.save
      redirect_to(@challenge, notice: "Challenge was successfully created.")
    else
      render(:new)
    end
  end

  def edit
    set_authorize
  end

  def update
    set_authorize
    if @challenge.update(challenge_params)
      redirect_to(@challenge, notice: "Challenge was successfully updated.")
    else
      render(:edit)
    end
  end

  def destroy
    set_authorize
    @challenge.destroy
    redirect_to(challenges_url, notice: "Challenge was successfully destroyed.")
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:id])
  end

  def set_authorize
    authorize(@challenge)
  end

  def challenge_params
    params.require(:challenge).permit(:start_date, :end_date, :title, :description, :difficulty, :category)
  end
end
