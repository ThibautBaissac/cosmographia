# frozen_string_literal: true

module User::Scopes
  extend ActiveSupport::Concern

  included do
    scope :guests, -> do
      where(first_name: [ nil, "" ])
        .or(where(last_name: [ nil, "" ]))
        .or(where(country_code: [ nil, "" ]))
    end

    scope :non_guests, -> {
      where.not(id: guests.select(:id))
    }

    scope :with_active_subscriptions, -> do
      joins(:subscriptions).where(pay_subscriptions: {status: "active"})
    end

    scope :with_subscription_name, ->(name) {
      with_active_subscriptions.where("pay_subscriptions.name ILIKE ?", "%#{sanitize_sql_like(name)}%")
    }

    scope :search, ->(query) do
      return none if query.blank?

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
    end

    scope :by_slug_prefix, ->(prefix) do
      return none if prefix.blank?

      normalized = prefix.to_s.strip.downcase
      where("LOWER(slug) LIKE ?", "#{normalized}%")
    end
  end
end
