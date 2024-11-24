class MapsController < ApplicationController
  def index
    maps = Map.all.includes(:user)
    @pagy, @maps = pagy(maps)
  end
end
