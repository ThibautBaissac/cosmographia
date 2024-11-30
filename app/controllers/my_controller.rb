class MyController < ApplicationController
  def show
    @maps = current_user.maps.includes(:image_attachment).last(5)
    @total_comment_count = current_user.comments.count
    @comments = current_user.comments.includes(:map).last(10)
    set_charts
  end

  private

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
end
