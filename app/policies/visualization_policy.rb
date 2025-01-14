class VisualizationPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

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
