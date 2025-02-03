class Visualizations::Filters::ProjectionFilter
  def initialize(params)
    @projections = params[:projections]
  end

  def call(scope)
    return scope unless @projections.present?

    @projections.shift if @projections.first.blank?
    return scope if @projections.empty? || @projections.include?("all")

    scope.where(projection: @projections.map(&:upcase))
  end
end
