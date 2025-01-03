class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if user_signed_in?
      @visualizations = Visualization.includes(:image_attachment).order(created_at: :desc).limit(12)
      set_contributions
      last_comments
      set_charts
    else
      @visualizations = Rails.cache.fetch("homepage/signed_out/visualizations", expires_in: 12.hours) do
        Visualizations::DailyRandom.new(visualization_count: 6).call
      end
    end
  end

  private

  def last_comments
    @last_comments = Visualization::Comment.includes(:user, visualization: :image_attachment).order(created_at: :desc).limit(4)
  end

  def set_charts
    @visualizations_over_time = Visualization.group_by_month(:creation_date).count
    @visualizations_by_projection = Visualization.group(:projection).count
    @software_usage = VisualizationSoftware.joins(:software).group("softwares.name").count
  end

  def set_contributions
    contribution_service = User::ContributionsService.new(current_user)
    @contributions_by_day = contribution_service.contributions_by_day
    @weeks = contribution_service.weeks
  end
end
