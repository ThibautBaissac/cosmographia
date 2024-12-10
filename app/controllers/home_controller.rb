class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if user_signed_in?
      @visualizations = Visualization.includes(:image_attachment).order(created_at: :desc).limit(9)
      last_comments
      set_charts
    else
      @visualizations = Visualizations::DailyRandom.new(visualization_count: 3).call
    end
  end

  private

  def last_comments
    @last_comments = Comment.includes(:user, visualization: :image_attachment).order(created_at: :desc).limit(5)
  end

  def set_charts
    @visualizations_over_time = Visualization.group_by_month(:creation_date).count
    @visualizations_by_projection = Visualization.group(:projection).count
    @software_usage = VisualizationSoftware.joins(:software).group("softwares.name").count
  end
end
