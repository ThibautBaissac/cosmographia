class UserPolicy < ApplicationPolicy
  def show?
    user&.current_plan?([ :basic, :premium ]) || record.public_profile || user&.superadmin?
  end

  def edit?
    user == record || user&.superadmin?
  end

  alias_method(:update?, :edit?)

  def permitted_attributes
    attrs = [ :first_name, :last_name, :country_code, :slug, :bio, :personal_website ]
    attrs << :public_profile if user.current_plan?(:premium)
    attrs << {social_links: Constants::Users::SOCIAL_LINK_KEYS}
    attrs << {user_softwares_attributes: [ :id, :software_id, :expertise, :_destroy ]}
    attrs
  end
end
