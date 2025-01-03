class Source < ApplicationRecord
  include Source::Scopes

  validates :name, presence: true
  validates :url, presence: true
end
