module Visualization::Scopes
  extend ActiveSupport::Concern

  included do
    scope :search, ->(query) do
      return all if query.blank?

      sanitized_query = "%#{sanitize_sql_like(query)}%"

      joins(:softwares)
      .where(
        "visualizations.title ILIKE :q OR
        visualizations.description ILIKE :q OR
        visualizations.sources ILIKE :q OR
        visualizations.geographic_coverage ILIKE :q OR
        softwares.name ILIKE :q OR
        softwares.category ILIKE :q",
        q: sanitized_query
        )
        .distinct
    end

      scope :random, -> { order(Arel.sql("RANDOM()")) }

    scope :creation_date_between, ->(start_date, end_date) do
      where(creation_date: start_date..end_date)
    end

    scope :scale_between, ->(min_scale, max_scale) do
      where(scale: min_scale..max_scale)
    end

    scope :with_projections, ->(projections) do
      return all if projections.blank? || projections.include?("all")
      where(projection: projections)
    end

    scope :with_software_names, ->(names) do
      joins(:softwares).where(softwares: {name: names}) if names.present?
    end

    scope :with_software_categories, ->(categories) do
      joins(:softwares).where(softwares: {category: categories}) if categories.present?
    end
  end
end
