class Challenges::DiscussionsController < ApplicationController
  before_action :set_challenge

  def create
    @discussion = @challenge.discussions.new(discussion_params)
    @discussion.user = current_user
    set_authorize

    respond_to do |format|
      if @discussion.save
        @toast_message = t("comments.flash.actions.create.success")
        format.turbo_stream
        format.html { redirect_to(@discussion) }
      else
        @toast_message = t("comments.flash.actions.create.failure")
        format.turbo_stream
        format.html { redirect_to(@discussion) }
      end
    end
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:challenge_id])
  end

  def set_authorize
    authorize(@discussion)
  end

  def discussion_params
    params.require(:challenge_discussion).permit(:content)
  end
end
