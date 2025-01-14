class Challenges::UserParticipationPolicy < ApplicationPolicy
  def create?
    user&.opted_in_directory? && !record.users.include?(user) && !record.ended?
  end

  def destroy?
    record.users.include?(user)
  end
end
