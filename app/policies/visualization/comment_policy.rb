class Visualization::CommentPolicy < ApplicationPolicy
  def create?
    user&.present? && user&.not_guest?
  end

  def edit?
    (create? && record.user == user) || user&.superadmin?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end
end
