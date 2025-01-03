class SourcesController < ApplicationController
  include Pagy::Backend

  def index
    authorize(Source)
    @source_query = params[:source_query]&.strip
    sources = Source.search(@source_query)
    @pagy, @sources = pagy(sources)
  end
end
