class MapsController < ApplicationController
  before_action :set_map, only: [ :edit, :update ]

  def index
    @query = params[:query]&.strip
    maps = Map.includes(:user, :image_attachment)
    maps = maps.includes(:softwares) if @query.present?
    maps = maps.search(@query).order(created_at: :desc)

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
    params.require(:map).permit(:title, :description, :creation_date, :scale, :sources, :geographic_coverage, :projection, :coordinate_system, :is_public)
  end
end
