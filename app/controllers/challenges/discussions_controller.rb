class Challenges::DiscussionsController < ApplicationController
  before_action :set_challenge
  before_action :set_discussion, only: [:edit, :update]

  def create
    @discussion = @challenge.discussions.new(discussion_params)
    @discussion.user = current_user
    set_authorize

    respond_to do |format|
      if @discussion.save
        @toast_message = t("challenge.discussion.flash.actions.create.success")
        format.turbo_stream
        format.html { redirect_to(discussion_challenge_path(@challenge)) }
      else
        @toast_message = t("challenge.discussion.flash.actions.create.failure")
        format.turbo_stream
        format.html { redirect_to(discussion_challenge_path(@challenge)) }
      end
    end
  end

  def edit
    set_authorize
  end

  def update
    set_authorize
    respond_to do |format|
      if @discussion.update(discussion_params)
        @toast_message = t("challenge.discussion.flash.actions.update.success")
        format.turbo_stream
        format.html { redirect_to(discussion_challenge_path(@challenge)) }
      else
        @toast_message = t("challenge.discussion.flash.actions.update.failure")
        format.turbo_stream
        format.html { redirect_to(discussion_challenge_path(@challenge)) }
      end
    end
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:challenge_id])
  end

  def set_discussion
    @discussion = @challenge.discussions.find(params[:id])
  end

  def set_authorize
    authorize(@discussion)
  end

  def discussion_params
    params.require(:challenge_discussion).permit(:content)
  end
end
