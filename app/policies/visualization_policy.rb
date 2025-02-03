class VisualizationPolicy < ApplicationPolicy
  def new?
    (user&.not_guest? && user&.has_remaining_visualizations?) || user&.superadmin?
  end

  def create?
    new?
  end

  def edit?
    record.user == user || user&.superadmin?
  end

  def update?
    edit?
  end
end
