module Users::Scopes
  extend ActiveSupport::Concern

  included do
    scope :opted_in_directory, -> { where(optin_directory: true, guest: false) }

    scope :search, ->(query) {
      return all if query.blank?

      sanitized_query = "%#{sanitize_sql_like(query)}%"

      joins(:softwares)
      .where(
        "users.first_name ILIKE :q OR
        users.last_name ILIKE :q OR
        users.email ILIKE :q OR
        softwares.name ILIKE :q OR
        softwares.category ILIKE :q",
        q: sanitized_query
        )
        .distinct
      }
  end
end
