class Maps::Filter
  def initialize(maps:, params:)
    @maps = maps
    @params = params
  end

  def apply
    query = @params[:query]
    @maps = query.present? ? @maps.search(query) : @maps
    filter_by_creation_date
    filter_by_scale
    filter_by_geographic_coverage
    filter_by_projection
    filter_by_software_names
    filter_by_software_categories

    @maps
  end

  private

  def filter_by_creation_date
    if @params[:creation_date_start].present?
      @maps = @maps.where("creation_date >= ?", @params[:creation_date_start])
    end

    if @params[:creation_date_end].present?
      @maps = @maps.where("creation_date <= ?", @params[:creation_date_end])
    end
  end

  def filter_by_scale
    if @params[:scale_min].present?
      @maps = @maps.where("scale >= ?", @params[:scale_min])
    end

    if @params[:scale_max].present?
      @maps = @maps.where("scale <= ?", @params[:scale_max])
    end
  end

  def filter_by_geographic_coverage
    if @params[:geographic_coverage].present?
      @maps = @maps.where(geographic_coverage: @params[:geographic_coverage].upcase)
    end
  end

  def filter_by_projection
    projections = @params[:projections]
    return unless projections.present?

    projections.shift if projections.first.blank?
    return if projections.empty? || projections.include?("all")

    @maps = @maps.where(projection: projections.map(&:upcase))
  end

  def filter_by_software_names
    if @params[:software_names].present?
      @maps = @maps.joins(:softwares).where(softwares: {name: @params[:software_names]})
    end
  end

  def filter_by_software_categories
    if @params[:software_categories].present?
      @maps = @maps.joins(:softwares).where(softwares: {category: @params[:software_categories]})
    end
  end
end
