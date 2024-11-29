class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @maps = random_maps_for_today
  end

  private

  def random_maps_for_today
    seed = Digest::MD5.hexdigest(Date.today.to_s).to_i(16) # Generate a seed based on the current date
    map_ids = Map.pluck(:id)
    random_ids = map_ids.shuffle(random: Random.new(seed)).first(3)
    Map.where(id: random_ids).includes(:image_attachment, :user)
  end
end
