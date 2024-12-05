class MapsController < ApplicationController
  before_action :set_map, only: [ :edit, :update ]

  def index
    @query = params[:query]&.strip
    maps = Map.includes(:user, :softwares, :image_attachment).references(:softwares, :user)

    filter = Maps::Filter.new(maps:, params: map_filter_params)
    @non_empty_params_count = Filter::ParamList.new(params: map_filter_params).non_empty.size
    maps = filter.apply.order(created_at: :desc).distinct

    @pagy, @maps = pagy(maps)
  end

  def show
    @map = Map.find(params[:id])
    @maps = Map.order("RANDOM()").includes(:user, :image_attachment).limit(10)
    @comment = Comment.new
  end


  def new
    @map = Map.new
  end

  def create
    @map = Map.new(map_params)
    @map.user_id = current_user.id

    if @map.save
      redirect_to(@map, notice: "Map was successfully created.")
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit
  end

  def update
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
