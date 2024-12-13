module Visualization::CustomValidations
  extend ActiveSupport::Concern

  included do
    def image_format
      return unless image.attached?
      return if image.blob.content_type.start_with?("image/")

      image.purge
      errors.add(:image, I18n.t("activerecord.errors.models.visualization.attributes.image.invalid_format"))
    end
  end
end
