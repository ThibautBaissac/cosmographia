class ChartsController < ApplicationController
  def index
    set_charts
  end

  private

  def set_charts
    @visualizations_over_time = Visualization.group_by_month(:creation_date).count
    @visualizations_by_projection = Visualization.group(:projection).count
    @software_usage = VisualizationSoftware.joins(:software).group("softwares.name").count
  end
end
