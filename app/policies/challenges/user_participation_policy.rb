class Challenges::UserParticipationPolicy < ApplicationPolicy
  def create?
    user&.opted_in_directory? && !record.users.include?(user)
  end

  def destroy?
    record.users.include?(user)
  end
end
