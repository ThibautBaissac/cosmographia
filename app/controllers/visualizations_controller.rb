class VisualizationsController < ApplicationController
  before_action :set_visualization, only: [ :edit, :update ]

  def index
    authorize(Visualization)
    @query = params[:query]&.strip
    visualizations = Visualization.includes(:user, :softwares, :image_attachment).references(:softwares, :user)

    filter = Visualizations::Filter.new(visualizations:, params: visualization_filter_params)
    @non_empty_params_count = Filter::ParamList.new(params: visualization_filter_params).non_empty.size
    visualizations = filter.apply.order(created_at: :desc).distinct

    @pagy, @visualizations = pagy(visualizations)
  end

  def show
    @visualization = Visualization.find(params[:id])
    set_authorize
    @visualizations = Visualization.order("RANDOM()").includes(:user, :image_attachment).limit(10)
    @comments = @visualization.comments.order(created_at: :desc)
    @new_comment = Comment.new
  end


  def new
    @visualization = Visualization.new
    set_authorize
  end

  def create
    @visualization = current_user.visualizations.new(visualization_params)
    set_authorize

    if @visualization.save
      redirect_to(@visualization, notice: "Visualization was successfully created.")
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit
    set_authorize
  end

  def update
    set_authorize
    if @visualization.update(visualization_params)
      redirect_to(@visualization, notice: "Visualization was successfully updated.")
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def set_visualization
    @visualization = Visualization.find(params[:id])
  end

  def set_authorize
    authorize(@visualization)
  end

  def visualization_params
    params.require(:visualization).permit(:category, :image, :title, :description, :creation_date, :scale, :sources, :geographic_coverage, :projection, software_ids: [])
  end

  def visualization_filter_params
    params.permit(
      :query,
      :creation_date_start,
      :creation_date_end,
      :scale_min,
      :scale_max,
      :geographic_coverage,
      categories: [],
      projections: []
    )
  end
end
