class Challenge::DiscussionPolicy < ApplicationPolicy
  def create?
    record.challenge.users.include?(user)
  end

  def edit?
    record.user == user
  end
end
