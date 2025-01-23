module User::Scopes
  extend ActiveSupport::Concern

  included do
    scope :guests, -> { where(first_name: [ nil, "" ]).or(where(last_name: [ nil, "" ])).or(where(country_code: [ nil, "" ])) }
    scope :non_guests, -> { where.not(id: guests.select(:id)) }

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
