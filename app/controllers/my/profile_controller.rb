class My::ProfileController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :show ]
  before_action :set_authorize, only: [ :edit, :update, :show ]

  def show
    @visualizations = @user.visualizations.includes(:image_attachment).last(5)
    @total_comment_count = @user.comments.count
    @comments = @user.comments.includes(visualization: :image_attachment).last(10)
    set_charts
  end

  def edit
  end

  def update
    if @user.update(user_params)
       @user.update(guest: false) if @user.profile_complete?
      redirect_to(my_profile_path, notice: "User was successfully updated.")
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_authorize
    authorize(@user)
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

  def user_params
    params.require(:user).permit(
      :locale,
      :first_name,
      :last_name,
      :bio,
      :personal_website,
      social_links: Constants::Users::SOCIAL_LINK_KEYS,
      software_ids: [])
  end
end
