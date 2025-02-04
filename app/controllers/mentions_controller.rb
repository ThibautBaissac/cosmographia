class MentionsController < ApplicationController
  def index
    @users = User.by_slug_prefix(params[:q])
                 .limit(10)
                 .select(:id, :slug)

    render json: @users
  end
end
