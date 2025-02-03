class Visualizations::Filters::SoftwareCategoriesFilter
  def initialize(params)
    @software_categories = params[:software_categories]
  end

  def call(scope)
    return scope unless @software_categories.present?

    scope.joins(:softwares).where(softwares: {category: @software_categories})
  end
end
