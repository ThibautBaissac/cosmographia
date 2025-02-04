class Visualizations::CommentsController < ApplicationController
  before_action :set_visualization
  before_action :set_comment, only: %i[edit update destroy]
  before_action :authorize_existing_comment, only: %i[edit update destroy]

  def create
    @comment = build_comment
    authorize(@comment)

    if @comment.save
      @toast_message = t("visualization.comments.flash.actions.create.success")
      respond_success
    else
      redirect_to(@visualization,
                  alert: t("visualization.comments.flash.actions.create.failure"))
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      @toast_message = t("visualization.comments.flash.actions.update.success")
      respond_success
    else
      redirect_to(@visualization,
                  alert: t("visualization.comments.flash.actions.update.failure"))
    end
  end

  def destroy
    @comment.destroy
    @toast_message = t("visualization.comments.flash.actions.destroy.success")
    respond_success
  end

  private

  def set_visualization
    @visualization = Visualization.find(params[:visualization_id])
  end

  def set_comment
    @comment = @visualization.comments.find(params[:id])
  end

  def authorize_existing_comment
    authorize(@comment)
  end

  def build_comment
    @visualization.comments.new(comment_params)
  end

  def comment_params
    params.require(:visualization_comment)
          .permit(:content)
          .merge(user: current_user)
  end

  def respond_success
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @visualization }
    end
  end
end
