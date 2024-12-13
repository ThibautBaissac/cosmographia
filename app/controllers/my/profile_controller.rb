class My::ProfileController < ApplicationController
  before_action :set_user
  before_action :set_authorize

  def show
    authorize(@user)
  end

  def edit
    Software.order(:name).each do |software|
      @user.user_softwares.find_or_initialize_by(software:)
    end
  end

  def update
    if @user.update(user_params)
       @user.update(guest: false) if @user.profile_complete?
      redirect_to(my_profile_path, notice: "User was successfully updated.")
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def set_user
    @user = current_user
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
