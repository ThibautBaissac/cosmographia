class Challenge::AttachVisualizationPolicy < ApplicationPolicy
  def new?
    record.users.include?(user) && record.ongoing?
  end

  alias_method(:create?, :new?)
end
