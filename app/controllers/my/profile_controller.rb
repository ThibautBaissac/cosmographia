class My::ProfileController < ApplicationController
  before_action :find_user
  before_action :authorize_resource

  def edit
    User::InitializeUserSoftwaresService.new(@user).call
  end

  def update
    result = User::ProfileUpdateService.new(@user, user_params).call

    if result.success?
      redirect_to(my_info_path(locale),
                  notice: t("my.profile.flash.actions.update.success"))
    else
      flash[:alert] = t("my.profile.flash.actions.update.failure")
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def find_user
    @user = User.includes(user_softwares: :software).find(current_user.id)
  end

  def authorize_resource
    authorize(@user)
  end

  def user_params
      params.require(:user).permit(policy(@user).permitted_attributes)
  end
end
