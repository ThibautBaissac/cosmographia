# frozen_string_literal: true

module User::Validations
  extend ActiveSupport::Concern

  included do
    # Normalizations
    normalizes :slug, with: ->(slug) { slug.strip.downcase }
    normalizes :email, with: ->(email) { email.strip.downcase }

    # Validations
    validates :locale, presence: true, inclusion: {in: Constants::Locales::SUPPORTED_LOCALES}
    validates :email, presence: true
    validates :first_name, :last_name, :country_code, presence: true, on: :profile_update
    validates :slug, presence: true, uniqueness: true,
                      exclusion: {in: Constants::Locales::SUPPORTED_LOCALES}
    validates :slug, length: {minimum: 4, maximum: 50},
                      format: {with: /\A[a-z0-9\-_]+\z/, message: :format}
    validates :country_code, inclusion: {in: ISO3166::Country.codes}, on: :profile_update

    # Custom validations
    validate :allowed_social_links_keys
  end

  def allowed_social_links_keys
    return if social_links.blank?

    invalid_keys = social_links.keys.map(&:to_s) - Constants::Users::SOCIAL_LINK_KEYS
    if invalid_keys.any?
      errors.add(:social_links, "contains invalid keys: #{invalid_keys.join(', ')}")
    end
  end
end
