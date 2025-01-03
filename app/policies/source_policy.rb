class SourcePolicy < ApplicationPolicy
  def index?
    user&.opted_in_directory? || user&.superadmin?
  end

  def destroy?
    user&.superadmin?
  end

  alias_method(:new?, :index?)
  alias_method(:create?, :index?)
  alias_method(:edit?, :index?)
  alias_method(:update?, :index?)
end
