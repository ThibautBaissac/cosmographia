class My::CommentsPolicy < ApplicationPolicy
  def show?
    user.present? && user == record
  end
end
