class MapsController < ApplicationController
  def index
    maps = Map.all.includes(:user, :image_attachment)
    @pagy, @maps = pagy(maps)
  end
end
