class My::Profile::TabsPolicy < ApplicationPolicy
  def user_info?
    user.present? && user == record
  end

  alias_method(:charts?, :user_info?)
  alias_method(:visualizations?, :user_info?)
  alias_method(:comments?, :user_info?)
end
