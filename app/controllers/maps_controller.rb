class MapsController < ApplicationController
  def index
    maps = Map.all.includes(:user, :image_attachment)
    @pagy, @maps = pagy(maps)
  end

  def show
    @map = Map.find(params[:id])
  end
end
