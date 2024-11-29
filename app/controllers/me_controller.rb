class MeController < ApplicationController
  def show
    @maps = current_user.maps.includes(:image_attachment).last(5)
    @total_comment_count = current_user.comments.count
    @comments = current_user.comments.includes(:map).last(10)
  end
end
