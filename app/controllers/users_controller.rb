class UsersController < ApplicationController
  before_action :find_user, only: [ :show ]
  before_action :authenticate_user!, unless: :user_public_profile?, only: [ :show ]

  def show
    authorize(@user)
    set_visualizations
  rescue Pundit::NotAuthorizedError
    redirect_back(fallback_location: root_path, alert: "Action not allowed") and return
  end

  private

  def find_user
    @user = User.find_by(slug: params[:slug])
  end

  def user_public_profile?
    @user&.public_profile
  end

  def set_visualizations
    @visualizations = @user.visualizations.includes(:image_attachment).last(5)
  end
end
