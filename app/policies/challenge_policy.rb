class ChallengePolicy < ApplicationPolicy
  def index?
    user&.not_guest?
  end

  def show?
    user&.not_guest?
  end

  def new?
    user&.superadmin?
  end

  alias_method(:new?, :create?)
  alias_method(:edit?, :create?)
  alias_method(:update?, :create?)
  alias_method(:detroy?, :create?)
end
