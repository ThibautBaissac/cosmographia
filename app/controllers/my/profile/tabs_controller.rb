class My::Profile::TabsController < ApplicationController
  before_action :set_user
  before_action :set_authorize

  def user_info
  end

  def charts
    set_charts
  end

  def comments
    @total_comment_count = @user.comments.count
    @comments = @user.comments.includes(visualization: :image_attachment)
    @pagy, @comments = pagy(@comments, limit: 5)
  end

  private

  def set_user
    @user = current_user
  end

  def set_authorize
    authorize(@user, policy_class: My::Profile::TabsPolicy)
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
