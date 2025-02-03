class Visualizations::Filters::CreationDateFilter
  def initialize(params)
    @start_date = params[:creation_date_start]
    @end_date   = params[:creation_date_end]
  end

  def call(scope)
    scope = scope.where("creation_date >= ?", @start_date) if @start_date.present?
    scope = scope.where("creation_date <= ?", @end_date)   if @end_date.present?
    scope
  end
end
