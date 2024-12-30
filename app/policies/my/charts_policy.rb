class My::ChartsPolicy < ApplicationPolicy
  def show?
    user.present? && user == record
  end
end
