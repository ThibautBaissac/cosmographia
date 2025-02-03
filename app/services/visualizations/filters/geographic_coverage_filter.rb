class Visualizations::Filters::GeographicCoverageFilter
  def initialize(params)
    @coverage = params[:geographic_coverage]
  end

  def call(scope)
    return scope unless @coverage.present?

    scope.where(geographic_coverage: @coverage.upcase)
  end
end
