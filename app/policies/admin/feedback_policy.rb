class Admin::FeedbackPolicy < ApplicationPolicy
  def index?
    user&.superadmin?
  end
end
