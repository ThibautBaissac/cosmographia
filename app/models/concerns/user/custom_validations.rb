module User::CustomValidations
  extend ActiveSupport::Concern

  included do
    def allowed_social_links_keys
      return if social_links.blank?

      invalid_keys = social_links.keys.map(&:to_s) - Constants::Users::SOCIAL_LINK_KEYS
      if invalid_keys.any?
        errors.add(:social_links, "contains invalid keys: #{invalid_keys.join(', ')}")
      end
    end
  end
end
