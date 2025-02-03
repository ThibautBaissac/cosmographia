class Visualizations::Filters::ScaleFilter
  def initialize(params)
    @scale_min = params[:scale_min]
    @scale_max = params[:scale_max]
  end

  def call(scope)
    scope = scope.where("scale >= ?", @scale_min) if @scale_min.present?
    scope = scope.where("scale <= ?", @scale_max) if @scale_max.present?
    scope
  end
end
