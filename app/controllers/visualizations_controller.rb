class VisualizationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  before_action :set_visualization, only: [ :edit, :update ]
  before_action :set_challenge, only: [ :new, :create ]

  def index
    @query = params[:query]&.strip
    visualizations = Visualization.all

    filter = Visualizations::Filter.new(visualizations:, params: visualization_filter_params)
    @non_empty_params_count = Filter::ParamList.new(params: visualization_filter_params).non_empty.size
    visualizations = filter.apply.order(created_at: :desc).distinct

    @pagy, @visualizations = pagy(visualizations.includes(:user, :image_attachment))
  end

  def show
    @visualization = Visualization.find(params[:id])
    @visualizations = Visualization.order("RANDOM()")
                                   .includes(:user, :image_attachment)
                                   .limit(6)
    @comments = @visualization.comments.order(created_at: :desc)
    @new_comment =  @visualization.comments.new
  end


  def new
    @visualization = Visualization.new
    @visualization.challenge = @challenge if @challenge
    set_authorize
  end

  def create
    @visualization = current_user.visualizations.new(visualization_params)
    @visualization.challenge = @challenge if @challenge
    set_authorize

    set_bounding_box
    if @visualization.save
      redirect_to(@visualization, notice: t("visualization.flash.actions.create.success"))
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit
    set_authorize
    @bounding_box = RGeo::GeoJSON.encode(@visualization.bounding_box).to_json
  end

  def update
    set_authorize
    set_bounding_box
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

  def set_challenge
    @challenge = Challenge.find_by(id: params[:challenge_id]) if params[:challenge_id].present?
  end

  def set_authorize
    authorize(@visualization)
  end

  def set_bounding_box
    if params[:visualization][:bounding_box].present?
      geojson = JSON.parse(params[:visualization][:bounding_box])
      factory = RGeo::Geographic.spherical_factory(srid: 4326)
      geometry = RGeo::GeoJSON.decode(geojson, geo_factory: factory)
      @visualization.bounding_box = geometry
    else
      @visualization.bounding_box = nil
    end
  end

  def visualization_params
    params.require(:visualization)
          .permit(:category,
                  :image,
                  :title,
                  :description,
                  :creation_date,
                  :scale,
                  :sources,
                  :geographic_coverage,
                  :projection,
                  software_ids: [])
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
