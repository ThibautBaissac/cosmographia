module Map::Scopes
  extend ActiveSupport::Concern

  included do
    scope :search, ->(query) {
      return all if query.blank?

      sanitized_query = "%#{sanitize_sql_like(query)}%"

      joins(:softwares, :user)
      .where(
        "maps.title ILIKE :q OR
        maps.description ILIKE :q OR
        maps.sources ILIKE :q OR
        maps.geographic_coverage ILIKE :q OR
        softwares.name ILIKE :q OR
        softwares.category ILIKE :q OR
        users.last_name ILIKE :q",
        q: sanitized_query
        )
        .distinct
      }

    scope :creation_date_between, ->(start_date, end_date) {
      where(creation_date: start_date..end_date)
    }

    scope :scale_between, ->(min_scale, max_scale) {
      where(scale: min_scale..max_scale)
    }

    scope :with_projections, ->(projections) {
      return all if projections.blank? || projections.include?("all")
      where(projection: projections)
    }

    scope :with_software_names, ->(names) {
      joins(:softwares).where(softwares: {name: names}) if names.present?
    }

    scope :with_software_categories, ->(categories) {
      joins(:softwares).where(softwares: {category: categories}) if categories.present?
    }
  end
end
