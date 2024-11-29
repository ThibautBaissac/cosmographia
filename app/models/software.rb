class Software < ApplicationRecord
  has_many :map_softwares, dependent: :destroy
  has_many :maps, through: :map_softwares

  validates :name, :category, presence: true
end
