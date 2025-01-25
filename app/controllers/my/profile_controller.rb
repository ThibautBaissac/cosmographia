class My::ProfileController < ApplicationController
  before_action :set_user
  before_action :set_authorize

  def edit
    User::InitializeUserSoftwaresService.new(@user).call
  end

  def update
    @user.assign_attributes(user_params)
    if @user.save(context: :profile_update)
      redirect_to(my_info_path(locale), notice: t("my.profile.flash.actions.update.success"))
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
    policy = UserPolicy.new(current_user, @user)
    params.require(:user).permit(policy.permitted_attributes)
  end
end
