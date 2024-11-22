class MapsController < ApplicationController
  def index
    @maps = Map.all.includes(:user)
  end
end
