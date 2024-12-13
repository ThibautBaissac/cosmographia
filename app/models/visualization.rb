class Visualization < ApplicationRecord
  include Visualization::Scopes
  include Visualization::CustomValidations

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
end
