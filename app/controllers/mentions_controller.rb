class MentionsController < ApplicationController
  def index
    if params[:q].present?
      query = params[:q].to_s.strip.downcase
      @users = User.where("LOWER(slug) LIKE ?", "#{query}%").limit(10)
    else
      @users = User.none
    end

    render json: @users.select(:id, :slug)
  end
end
