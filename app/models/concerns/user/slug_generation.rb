# frozen_string_literal: true

module User::SlugGeneration
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug, on: %i[create update]
  end

  def generate_slug
    base_slug = determine_base_slug
    self.slug = unique_slug(base_slug)
  end

  private

  def determine_base_slug
    if fullname.present?
      fullname.downcase.parameterize
    else
      email.split("@").first.parameterize
    end
  end

  def unique_slug(base_slug)
    slug_candidate = base_slug
    counter = 1

    while ::User.where(slug: slug_candidate).where.not(id: id).exists?
      slug_candidate = "#{base_slug}-#{counter}"
      counter += 1
    end

    slug_candidate
  end
end
