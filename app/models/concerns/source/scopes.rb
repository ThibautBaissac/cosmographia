module Source::Scopes
  extend ActiveSupport::Concern

  included do
    scope :search, ->(query) {
      return all if query.blank?

      sanitized_query = "%#{sanitize_sql_like(query)}%"

      where(
        "sources.name ILIKE :q OR
        sources.location ILIKE :q OR
        sources.description ILIKE :q",
        q: sanitized_query
        )
        .distinct
      }
  end
end
