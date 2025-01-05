class ChallengePolicy < ApplicationPolicy
  def index?
    user&.opted_in_directory? || user&.superadmin?
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
