class MapsController < ApplicationController
  before_action :set_map, only: [ :edit, :update ]

  def index
    authorize(Map)
    @query = params[:query]&.strip
    maps = Map.includes(:user, :softwares, :image_attachment).references(:softwares, :user)

    filter = Maps::Filter.new(maps:, params: map_filter_params)
    @non_empty_params_count = Filter::ParamList.new(params: map_filter_params).non_empty.size
    maps = filter.apply.order(created_at: :desc).distinct

    @pagy, @maps = pagy(maps)
  end

  def show
    @map = Map.find(params[:id])
    set_authorize
    @maps = Map.order("RANDOM()").includes(:user, :image_attachment).limit(10)
    @comments = @map.comments.order(created_at: :desc)
    @new_comment = Comment.new
  end


  def new
    @map = Map.new
    set_authorize
  end

  def create
    @map = current_user.maps.new(map_params)
    set_authorize

    if @map.save
      redirect_to(@map, notice: "Map was successfully created.")
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit
    set_authorize
  end

  def update
    set_authorize
    if @map.update(map_params)
      redirect_to(@map, notice: "Map was successfully updated.")
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def set_map
    @map = Map.find(params[:id])
  end

  def set_authorize
    authorize(@map)
  end

  def map_params
    params.require(:map).permit(:title, :description, :creation_date, :scale, :sources, :geographic_coverage, :projection, :is_public, software_ids: [])
  end

  def map_filter_params
    params.permit(
      :query,
      :creation_date_start,
      :creation_date_end,
      :scale_min,
      :scale_max,
      projections: []
    )
  end
end
