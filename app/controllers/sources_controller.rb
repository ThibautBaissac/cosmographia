class SourcesController < ApplicationController
  before_action :set_source, only: %i[edit update destroy]
  before_action :set_authorize, only: %i[edit update destroy]

  def index
    authorize(Source)
    @source_query = params[:source_query]&.strip
    sources = Source.search(@source_query)
                    .order(Arel.sql("LOWER(name) ASC"))
    @pagy, @sources = pagy(sources)
  end

  def new
    @source = Source.new
    authorize(@source)
  end

  def create
    @source = Source.new(source_params)
    set_authorize

    if @source.save
      redirect_to(sources_path(locale), notice: t("source.flash.actions.create.success"))
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit
    authorize(@source)
  end

  def update
    authorize(@source)
    if @source.update(source_params)
      flash[:notice] = t("source.flash.actions.update.success")
    else
      flash[:alert] = t("source.flash.actions.update.failure")
    end
    redirect_to(sources_path(locale))
  end

  def destroy
    @source.destroy
    redirect_to(sources_path(locale), notice: "Source was successfully destroyed.")
  end

  private

  def set_source
    @source = Source.find(params[:id])
  end

  def source_params
    params.require(:source).permit(:name, :url, :location, :description)
  end

  def set_authorize
    authorize(@source)
  end
end
