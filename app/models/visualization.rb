class Visualization < ApplicationRecord
  include Visualization::Scopes

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :visualization_softwares, dependent: :destroy
  has_many :softwares, through: :visualization_softwares
  has_one_attached :image


  validates :title, presence: true
  validates :image, presence: true
  validates :category, presence: true
  validates :description, presence: true
  validate :image_format

  string_enum category: Constants::Visualizations::CATEGORY
  string_enum projection: Constants::Visualizations::PROJECTIONS
  string_enum geographic_coverage: Constants::Visualizations::GEOGRAPHIC_COVERAGE

  private

  def image_format
    return unless image.attached?
    return if image.blob.content_type.start_with?("image/")

    image.purge
    errors.add(:image, I18n.t("activerecord.errors.models.visualization.attributes.image.invalid_format"))
  end
end
