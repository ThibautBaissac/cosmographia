class My::ChartsController < ApplicationController
  before_action :set_user
  before_action :set_authorize

  def show
    set_charts
  end

  private

  def set_user
    @user = current_user
  end

  def set_authorize
    authorize(@user, policy_class: My::ChartsPolicy)
  end

  def set_charts
    @visualizations_over_time = @user.visualizations.group_by_month(:creation_date).count
    @comments_over_time = @user.comments.group_by_month(:created_at).count
    @comments_per_visualization = @user.visualizations.joins(:comments).group(:title).count
    @software_usage = @user.visualizations
                                  .joins(visualization_softwares: :software) # Explicitly join softwares
                                  .group("softwares.name")
                                  .count
    @scale_distribution = @user.visualizations.group(:scale).count
  end
end
