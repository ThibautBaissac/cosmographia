class FeedbackPolicy < ApplicationPolicy
  def create?
    user&.present?
  end
end
