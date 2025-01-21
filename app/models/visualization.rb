class Visualization < ApplicationRecord
  include Visualization::Scopes
  include Visualization::CustomValidations

  belongs_to :user
  has_many :comments, class_name: "Visualization::Comment", dependent: :destroy
  has_many :visualization_softwares, dependent: :destroy
  has_many :softwares, through: :visualization_softwares
  belongs_to :challenge, optional: true
  has_one_attached :image

  validates :title, presence: true
  validates :image, presence: true
  validates :category, presence: true
  validates :description, presence: true
  validate :image_format

  string_enum category: Constants::Visualizations::CATEGORY
  string_enum projection: Constants::Visualizations::PROJECTIONS
  string_enum geographic_coverage: Constants::Visualizations::GEOGRAPHIC_COVERAGE

  def image_variant(name)
    dimensions = Constants::Visualizations::VARIANT_SIZES[name]
    return unless dimensions

    image.variant(resize_to_limit: dimensions)
  end

  Constants::Visualizations::VARIANT_SIZES.keys.each do |variant_name|
    define_method("image_#{variant_name}") do
      image_variant(variant_name)
    end
  end
end
