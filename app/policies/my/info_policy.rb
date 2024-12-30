class My::InfoPolicy < ApplicationPolicy
  def show?
    user.present? && user == record
  end
end
