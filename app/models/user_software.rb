class UserSoftware < ApplicationRecord
  belongs_to :software
  belongs_to :user

  string_enum expertise: Constants::UserSoftwares::EXPERTISES
end
