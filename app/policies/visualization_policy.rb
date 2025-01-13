class VisualizationPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def new?
    (user&.not_guest? || user&.superadmin?) && user&.remaining_visualization_count&.positive?
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
