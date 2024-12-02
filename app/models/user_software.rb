class UserSoftware < ApplicationRecord
  belongs_to :software
  belongs_to :user
end
