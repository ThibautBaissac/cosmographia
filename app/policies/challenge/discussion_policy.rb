class Challenge::DiscussionPolicy < ApplicationPolicy
  def create?
    record.challenge.users.include?(user)
  end

  def edit?
    record.user == user || user.superadmin?
  end

  alias_method(:update?, :edit?)
  alias_method(:destroy?, :edit?)
end
