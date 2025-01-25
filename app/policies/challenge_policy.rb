class ChallengePolicy < ApplicationPolicy
  def index?
    (user&.not_guest? && user&.subscribed?) || user&.superadmin?
  end

  def new?
    user&.superadmin? || user&.current_plan?(:premium)
  end

  def destroy?
    user&.current_plan?(:premium)
  end

  alias_method(:edit?, :new?)
  alias_method(:create?, :new?)
  alias_method(:update?, :new?)

  alias_method(:participations?, :index?)
  alias_method(:discussion?, :index?)
end
