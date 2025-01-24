class ChallengePolicy < ApplicationPolicy
  def index?
    (user&.not_guest? && user&.subscribed?) || user&.superadmin?
  end

  def new?
    user&.superadmin?
  end

  alias_method(:edit?, :new?)
  alias_method(:create?, :new?)
  alias_method(:update?, :new?)
  alias_method(:destroy?, :new?)

  alias_method(:participations?, :index?)
  alias_method(:discussion?, :index?)
end
