module User::Callbacks
  extend ActiveSupport::Concern

  included do
    def generate_slug
      base_slug = fullname.present? ? fullname.downcase.parameterize : email.split("@").first.parameterize
      self.slug = base_slug

      existing_slugs = User.where.not(id: self.id).pluck(:slug)

      if existing_slugs.include?(base_slug)
        counter = 1
        while User.exists?(slug: "#{base_slug}-#{counter}")
          counter += 1
        end
        self.slug = "#{base_slug}-#{counter}"
      end
    end
  end
end
