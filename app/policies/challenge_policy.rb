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

  alias_method(:edit?, :new?)
  alias_method(:update?, :new?)
  alias_method(:detroy?, :new?)
end
