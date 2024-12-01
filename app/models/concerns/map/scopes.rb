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
          CAST(maps.creation_date AS TEXT) ILIKE :q OR
          CAST(maps.scale AS TEXT) ILIKE :q OR
          maps.sources ILIKE :q OR
          maps.geographic_coverage ILIKE :q OR
          maps.projection ILIKE :q OR
          maps.coordinate_system ILIKE :q OR
          softwares.name ILIKE :q OR
          softwares.category ILIKE :q OR
          users.email ILIKE :q",
          q: sanitized_query
        )
        .distinct
    }
  end
end
