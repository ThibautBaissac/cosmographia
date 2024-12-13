class UserSoftware < ApplicationRecord
  belongs_to :software
  belongs_to :user

  validates :level, presence: true, inclusion: {in: 1..Constants::UserSoftwares::MAX_LEVEL}
end
