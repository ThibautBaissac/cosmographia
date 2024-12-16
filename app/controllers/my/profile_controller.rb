class My::ProfileController < ApplicationController
  before_action :set_user
  before_action :set_authorize

  def show
  end

  def edit
    User::InitializeUserSoftwaresService.new(@user).call
  end

  def update
    update_service = User::UpdateUserProfileService.new(@user, user_params)

    if update_service.call
      redirect_to(my_profile_path(locale), notice: t("my.profile.flash.actions.update.success"))
    else
      flash[:alert] = t("my.profile.flash.actions.update.failure")
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def set_user
    @user = User.includes(user_softwares: :software).find(current_user.id)
  end

  def set_authorize
    authorize(@user)
  end

  def user_params
    params.require(:user).permit(
      :locale,
      :first_name,
      :last_name,
      :slug,
      :bio,
      :personal_website,
      :optin_directory,
      social_links: Constants::Users::SOCIAL_LINK_KEYS,
      user_softwares_attributes: [ :id, :software_id, :level, :_destroy ]
    )
  end
end
