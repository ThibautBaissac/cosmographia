class Admin::UsersController < ApplicationController
  before_action :require_superadmin!

  def index
    users = User.order(:last_name, :first_name)
    @pagy, @users = pagy(users)
  end

  def impersonate
    user = User.find(params[:id])
    impersonate_user(user)
    redirect_to(root_path)
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to(root_path)
  end
end
