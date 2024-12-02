class MyController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :show ]

  def show
    @user = current_user
    @maps = current_user.maps.includes(:image_attachment).last(5)
    @total_comment_count = current_user.comments.count
    @comments = current_user.comments.includes(:map).last(10)
    set_charts
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to(my_path, notice: "User was successfully updated.")
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_charts
    @maps_over_time = current_user.maps.group_by_month(:creation_date).count
    @comments_over_time = current_user.comments.group_by_month(:created_at).count
    @comments_per_map = current_user.maps.joins(:comments).group(:title).count
    @software_usage = current_user.maps
                                  .joins(map_softwares: :software) # Explicitly join softwares
                                  .group("softwares.name")
                                  .count
    @scale_distribution = current_user.maps.group(:scale).count
  end

  def user_params
    params.require(:user).permit(:locale, :first_name, :last_name, :bio, :personal_website, social_links: {})
  end
end
