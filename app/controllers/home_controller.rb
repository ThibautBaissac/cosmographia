class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if user_signed_in?
      @columns = Maps::ColumnDistributed.new(column_count: 3, map_count: 9).call
    else
      @maps = Maps::DailyRandom.new(map_count: 3).call
    end
  end
end
