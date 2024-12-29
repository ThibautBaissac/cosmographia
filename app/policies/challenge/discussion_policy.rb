class Challenge::DiscussionPolicy < ApplicationPolicy
  def edit?
    record.user == user
  end
end
