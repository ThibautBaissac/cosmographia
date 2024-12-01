class Software < ApplicationRecord
  has_many :map_softwares, dependent: :destroy
  has_many :maps, through: :map_softwares

  validates :name, :category, presence: true

  string_enum category: %w[gis raster vector code images images_processing database other]
end
