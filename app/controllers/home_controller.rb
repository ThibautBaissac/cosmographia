class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if user_signed_in?
      @columns = distribute_maps_into_columns(3)
    else
      @maps = random_maps_for_today
    end
  end

  private

  def distribute_maps_into_columns(number_of_columns)
    maps = Map.limit(10).includes(:image_attachment, :user)
    maps.group_by.with_index { |_, index| index % number_of_columns }.values
  end

  def random_maps_for_today
    seed = Digest::MD5.hexdigest(Date.today.to_s).to_i(16) # Generate a seed based on the current date
    map_ids = Map.pluck(:id)
    random_ids = map_ids.shuffle(random: Random.new(seed)).first(3)
    Map.where(id: random_ids).includes(:image_attachment, :user)
  end
end
