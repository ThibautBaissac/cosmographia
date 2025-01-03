class Software < ApplicationRecord
  has_many :user_softwares, dependent: :destroy
  has_many :users, through: :user_softwares
  has_many :visualization_softwares, dependent: :destroy
  has_many :visualizations, through: :visualization_softwares

  validates :name, :category, presence: true

  string_enum category: %w[gis raster vector code images images_processing database other]
end
