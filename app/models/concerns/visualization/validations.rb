module Visualization::Validations
  extend ActiveSupport::Concern

  included do
    validates :title, presence: true
    validates :image, presence: true
    validates :category, presence: true
    validates :description, presence: true
    validate :image_format
  end

  def image_format
    return unless image.attached?
    return if image.blob.content_type.start_with?("image/")

    image.purge
    errors.add(:image, I18n.t("activerecord.errors.models.visualization.attributes.image.invalid_format"))
  end
end
