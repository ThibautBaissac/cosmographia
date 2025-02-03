class Visualizations::Filter
  def initialize(visualizations:, params:)
    @visualizations = visualizations
    @params = params
    @filters = [
      Visualizations::Filters::QueryFilter.new(@params),
      Visualizations::Filters::CategoryFilter.new(@params),
      Visualizations::Filters::CreationDateFilter.new(@params),
      Visualizations::Filters::ScaleFilter.new(@params),
      Visualizations::Filters::GeographicCoverageFilter.new(@params),
      Visualizations::Filters::ProjectionFilter.new(@params),
      Visualizations::Filters::SoftwareNamesFilter.new(@params),
      Visualizations::Filters::SoftwareCategoriesFilter.new(@params),
      Visualizations::Filters::BoundingBoxFilter.new(@params)
    ]
  end

  def call
    @filters.inject(@visualizations) do |scope, filter|
      filter.call(scope)
    end
  end
end
