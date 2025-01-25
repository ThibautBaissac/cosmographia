class UserPolicy < ApplicationPolicy
  def show?
    record&.current_plan?([ :basic, :premium ]) || record.public_profile || user&.superadmin?
  end

  def edit?
    user == record || user&.superadmin?
  end

  alias_method(:update?, :edit?)
end
