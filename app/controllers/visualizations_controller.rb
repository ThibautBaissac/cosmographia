class VisualizationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_visualization, only: [:show, :edit, :update]
  before_action :set_challenge, only: [:new, :create]
  before_action :build_visualization, only: [:new, :create]
  before_action :authorize_resource, only: [:new, :create, :edit, :update]
  before_action :apply_bounding_box, only: [:create, :update]

  def index
    @query = params[:query]&.strip
    visualizations = Visualization.all

    filter = Visualizations::Filter.new(
      visualizations: visualizations,
      params: visualization_filter_params
    )
    @non_empty_params_count = Filter::ParamList.new(params: visualization_filter_params).non_empty.size

    visualizations = filter.call.order(created_at: :desc).distinct
    @pagy, @visualizations = pagy(visualizations.includes(:user, :image_attachment))
  end

  def show
    @visualizations = Visualization.random.includes(:user, :image_attachment).limit(6)
    @comments       = @visualization.comments.order(created_at: :desc)
    @new_comment    = @visualization.comments.new
  end

  def new
    @visualization.challenge ||= @challenge if @challenge
  end

  def create
    @visualization.challenge ||= @challenge if @challenge

    if @visualization.save
      redirect_to(@visualization, notice: t("visualization.flash.actions.create.success"))
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit
    @bounding_box = RGeo::GeoJSON.encode(@visualization.bounding_box).to_json
  end

  def update
    if @visualization.update(visualization_params)
      redirect_to(@visualization, notice: t("visualization.flash.actions.update.success"))
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def set_visualization
    @visualization = Visualization.find(params[:id])
  end

  def build_visualization
    @visualization = if action_name == "new"
                       Visualization.new
                     elsif action_name == "create"
                       current_user.visualizations.new(visualization_params)
                     end
  end

  def set_challenge
    @challenge = Challenge.find_by(id: params[:challenge_id]) if params[:challenge_id].present?
  end

  def authorize_resource
    authorize(@visualization)
  end

  def apply_bounding_box
    bbox_param = params.dig(:visualization, :bounding_box)
    @visualization.bounding_box = Visualizations::BoundingBoxService.call(bbox_param)
  end

  def visualization_params
    params.require(:visualization).permit(
      :category,
      :image,
      :title,
      :description,
      :creation_date,
      :scale,
      :sources,
      :geographic_coverage,
      :projection,
      software_ids: []
    )
  end

  def visualization_filter_params
    params.permit(
      :query,
      :bounding_box,
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
