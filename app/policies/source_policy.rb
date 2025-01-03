class SourcePolicy < ApplicationPolicy
  def index?
    user&.opted_in_directory? || user&.superadmin?
  end
end
