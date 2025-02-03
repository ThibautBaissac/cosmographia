class Visualizations::Filters::CategoryFilter
  def initialize(params)
    @categories = params[:categories]
  end

  def call(scope)
    return scope unless @categories.present?

    categories = @categories.reject(&:blank?)
    return scope if categories.empty?

    scope.where(category: categories.map(&:upcase))
  end
end
