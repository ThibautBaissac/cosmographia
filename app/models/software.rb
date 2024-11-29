class Software < ApplicationRecord
  validates :name, :code, presence: true
end
