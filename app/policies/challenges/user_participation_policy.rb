class Challenges::UserParticipationPolicy < ApplicationPolicy
  def create?
    user&.subscribed? && !record.users.include?(user) && !record.ended?
  end

  def destroy?
    record.users.include?(user)
  end
end
