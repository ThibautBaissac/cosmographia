class Community::DirectoryController < ApplicationController
  def show
    @user_query = params[:user_query]&.strip
    users = User.with_active_subscriptions.includes(:softwares)
    user_query = user_filter_params[:user_query]

    filter = Users::Filter.new(scope: users, user_query:)
    filtered_users = filter.apply.order(created_at: :desc).distinct

    @pagy, @users = pagy(filtered_users)
  end

  private

  def user_filter_params
    params.permit(:user_query)
  end
end
