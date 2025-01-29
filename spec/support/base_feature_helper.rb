module BaseFeatureHelper
  def sign_in_as(email:, password:)
    visit(new_user_session_path(locale: user.locale))
    fill_in("user[email]", with: user.email)
    fill_in("user[password]", with: user.password)
    click_on("submit_sign_in")
  end
end
