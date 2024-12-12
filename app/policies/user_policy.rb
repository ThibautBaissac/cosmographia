class UserPolicy < ApplicationPolicy
  def show?
    return false if user.blank?
    return true if record.public_profile? || user.not_guest? || user == record
    false
  end

  alias_method(:edit?, :show?)
  alias_method(:update?, :show?)
end
