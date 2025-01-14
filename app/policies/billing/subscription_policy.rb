class Billing::SubscriptionPolicy < ApplicationPolicy
  def index?
    user&.present?
  end

  def new?
    user&.not_guest?
  end

  def show?
    record.user == user || user&.superadmin?
  end

  alias_method(:create?, :new?)
  alias_method(:destroy?, :show?)
end
