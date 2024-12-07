class Map < ApplicationRecord
  include Map::Scopes

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :map_softwares, dependent: :destroy
  has_many :softwares, through: :map_softwares
  has_one_attached :image

  validates :title, presence: true

  string_enum projection: Constants::Maps::PROJECTIONS
  string_enum geographic_coverage: Constants::Maps::GEOGRAPHIC_COVERAGE
end
