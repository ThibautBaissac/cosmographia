class Visualizations::Filters::QueryFilter
  def initialize(params)
    @query = params[:query]
  end

  def call(scope)
    return scope unless @query.present?

    scope.search(@query)
  end
end
