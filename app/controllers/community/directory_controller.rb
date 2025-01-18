class Community::DirectoryController < ApplicationController
  def show
    @user_query = params[:user_query]&.strip
    users = User.non_guests.includes(:softwares)

    filter = Users::Filter.new(users:, params: user_filter_params)
    users = filter.apply.order(created_at: :desc).distinct

    @pagy, @users = pagy(users)
  end

  private

  def user_filter_params
    params.permit(:user_query)
  end
end
