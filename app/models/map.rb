class Map < ApplicationRecord
  include Map::Projections
  include Map::Scopes

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :map_softwares, dependent: :destroy
  has_many :softwares, through: :map_softwares
  has_one_attached :image

  validates :title, presence: true
end
