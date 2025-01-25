# frozen_string_literal: true

module User::SlugGeneration
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug, on: %i[create update]
  end

  def generate_slug
    base_slug = if fullname.present?
                  fullname.downcase.parameterize
    else
                  email.split("@").first.parameterize
    end

    self.slug = base_slug
    existing_slugs = ::User.where.not(id: id).pluck(:slug)

    if existing_slugs.include?(base_slug)
      counter = 1
      while ::User.exists?(slug: "#{base_slug}-#{counter}")
        counter += 1
      end
      self.slug = "#{base_slug}-#{counter}"
    end
  end
end
