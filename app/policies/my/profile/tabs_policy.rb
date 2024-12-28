class My::Profile::TabsPolicy < ApplicationPolicy
  def info?
    user.present? && user == record
  end

  alias_method(:charts?, :info?)
  alias_method(:comments?, :info?)
end
