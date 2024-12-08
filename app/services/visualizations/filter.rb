class Visualizations::Filter
  def initialize(visualizations:, params:)
    @visualizations = visualizations
    @params = params
  end

  def apply
    query = @params[:query]
    @visualizations = query.present? ? @visualizations.search(query) : @visualizations
    filter_by_creation_date
    filter_by_scale
    filter_by_geographic_coverage
    filter_by_projection
    filter_by_software_names
    filter_by_software_categories

    @visualizations
  end

  private

  def filter_by_creation_date
    if @params[:creation_date_start].present?
      @visualizations = @visualizations.where("creation_date >= ?", @params[:creation_date_start])
    end

    if @params[:creation_date_end].present?
      @visualizations = @visualizations.where("creation_date <= ?", @params[:creation_date_end])
    end
  end

  def filter_by_scale
    if @params[:scale_min].present?
      @visualizations = @visualizations.where("scale >= ?", @params[:scale_min])
    end

    if @params[:scale_max].present?
      @visualizations = @visualizations.where("scale <= ?", @params[:scale_max])
    end
  end

  def filter_by_geographic_coverage
    if @params[:geographic_coverage].present?
      @visualizations = @visualizations.where(geographic_coverage: @params[:geographic_coverage].upcase)
    end
  end

  def filter_by_projection
    projections = @params[:projections]
    return unless projections.present?

    projections.shift if projections.first.blank?
    return if projections.empty? || projections.include?("all")

    @visualizations = @visualizations.where(projection: projections.map(&:upcase))
  end

  def filter_by_software_names
    if @params[:software_names].present?
      @visualizations = @visualizations.joins(:softwares).where(softwares: {name: @params[:software_names]})
    end
  end

  def filter_by_software_categories
    if @params[:software_categories].present?
      @visualizations = @visualizations.joins(:softwares).where(softwares: {category: @params[:software_categories]})
    end
  end
end
