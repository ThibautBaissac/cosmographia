class UserPolicy < ApplicationPolicy
  def show?
    return true if record.public_profile?
    return false if user.nil?

    permitted_to_view_profile?
  end

  def edit?
    return false if user.nil?

    permitted_to_edit_profile?
  end

  alias_method(:update?, :edit?)

  private

  def permitted_to_view_profile?
    user.not_guest? || user == record || user.superadmin?
  end

  def permitted_to_edit_profile?
    user == record || user.superadmin?
  end
end
