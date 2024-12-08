class CommentsController < ApplicationController
  before_action :set_visualization
  before_action :set_comment, only: %i[edit update destroy]

  def create
    @comment = @visualization.comments.new(comment_params)
    set_authorize

    respond_to do |format|
      if @comment.save
        format.turbo_stream
        format.html { redirect_to(@visualization, notice: "Comment created") }
      else
        format.turbo_stream
        format.html { redirect_to(@visualization, alert: "Comment not created") }
      end
    end
  end

  def edit
    set_authorize
  end

  def update
    set_authorize
    respond_to do |format|
      if @comment.update(comment_params)
        format.turbo_stream
        format.html { redirect_to(@visualization, notice: "Comment created") }
      else
        format.turbo_stream
        format.html { redirect_to(@visualization, alert: "Comment not created") }
      end
    end
  end

  def destroy
    set_authorize
    @comment.destroy
  end

  private

  def set_visualization
    @visualization = Visualization.find(params[:visualization_id])
  end

  def set_comment
    @comment = @visualization.comments.find(params[:id])
  end

  def set_authorize
    authorize(@comment)
  end

  def comment_params
    params.require(:comment).permit(:content).merge(user: current_user)
  end
end
