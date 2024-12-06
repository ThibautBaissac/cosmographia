class UserPolicy < ApplicationPolicy
  def show?
    user.present? && user == record
  end

  def edit?
    show?
  end

  def update?
    show?
  end
end
