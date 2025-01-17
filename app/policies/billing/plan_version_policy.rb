class Billing::PlanVersionPolicy < ApplicationPolicy
  def checkout?
    user&.not_guest?
  end
end
