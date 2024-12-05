class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if user_signed_in?
      @columns = Maps::ColumnDistributed.new(column_count: 3, map_count: 9).call
      last_comments
      set_charts
    else
      @maps = Maps::DailyRandom.new(map_count: 3).call
    end
  end

  private

  def last_comments
    @last_comments = Comment.includes(:user, map: :image_attachment).order(created_at: :desc).limit(5)
  end

  def set_charts
    @maps_over_time = Map.group_by_month(:creation_date).count
    @maps_by_projection = Map.group(:projection).count
    @software_usage = MapSoftware.joins(:software).group("softwares.name").count
  end
end
