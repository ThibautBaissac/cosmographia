class Visualizations::Filters::SoftwareNamesFilter
  def initialize(params)
    @software_names = params[:software_names]
  end

  def call(scope)
    return scope unless @software_names.present?

    scope.joins(:softwares).where(softwares: {name: @software_names})
  end
end
