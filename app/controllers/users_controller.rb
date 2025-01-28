class UsersController < ApplicationController
  before_action :find_user, only: [ :show ]
  before_action :authenticate_user!, unless: :user_public_profile?, only: [ :show ]

  def show
    authorize(@user)
    set_visualizations
    set_contributions
    @pagy, @visualizations = pagy(@visualizations)
  rescue Pundit::NotAuthorizedError
    redirect_back(fallback_location: root_path(locale), alert: t("user.not_allowed")) and return
  end

  private

  def find_user
    @user = User.includes(user_softwares: :software).find_by(slug: params[:slug])
    if @user.nil?
      redirect_back(fallback_location: root_path(locale), alert: t("user.not_found")) and return
    end
  end

  def user_public_profile?
    authorize(@user)
  end

  def set_visualizations
    @visualizations = @user.visualizations.includes(:image_attachment)
  end

  def set_contributions
    contribution_service = User::ContributionsService.new(@user)
    @contributions_by_day = contribution_service.contributions_by_day
    @weeks = contribution_service.weeks
  end
end
