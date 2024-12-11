class UserPolicy < ApplicationPolicy
  def show?
    user.present? && user == record
  end

  alias_method(:edit?, :show?)
  alias_method(:update?, :show?)
  alias_method(:user_info?, :show?)
  alias_method(:charts?, :show?)
  alias_method(:visualizations?, :show?)
  alias_method(:comments?, :show?)
end
