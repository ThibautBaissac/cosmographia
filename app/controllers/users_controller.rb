class UsersController < ApplicationController
  before_action :find_user, only: [ :show ]
  before_action :authenticate_user!, unless: :user_public_profile?, only: [ :show ]

  def show
    authorize(@user)
    load_visualizations
    load_contributions
    @pagy, @visualizations = pagy(@visualizations)
  end

  private

  def find_user
    @user = User.includes(user_softwares: :software).find_by(slug: params[:slug])
    return if @user.present?

    redirect_back(fallback_location: root_path(locale), alert: t("user.not_found"))
  end

  def user_public_profile?
    authorize(@user)
  end

  def load_visualizations
    @visualizations = @user.visualizations.includes(:image_attachment)
  end

  def load_contributions
    contributions_service = UserContributions::ContributionsService.new(
      @user,
      range: 1.year.ago..Time.current
    )
    @contributions_by_day = contributions_service.contributions_by_day
    @weeks = contributions_service.weeks
  end
end
