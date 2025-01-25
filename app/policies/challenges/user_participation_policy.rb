class Challenges::UserParticipationPolicy < ApplicationPolicy
  def create?
    user&.has_remaining_challenges? && !record.users.include?(user) && !record.ended?
  end

  def destroy?
    record.users.include?(user)
  end
end
