require 'rails_helper'

RSpec.feature("SignIn", type: :feature) do
  let(:user) { create(:user) }

  context "with valid credentials" do
    scenario "User signs in successfully" do
      # I18n.locale = :en
      visit new_user_session_path(locale: user.locale)
      fill_in "user[email]", with: user.email
      fill_in "user[password]", with: user.password
      click_on("submit_sign_in")

      expect(page).to(have_content(I18n.t("devise.sessions.signed_in", locale: user.locale)))
      expect(current_path).to(eq(root_path(user.locale)))
    end
  end

  context "with invalid credentials" do
    scenario "User sees an error message when email is incorrect" do
      visit new_user_session_path(locale: user.locale)
      fill_in "user[email]", with: "wrong@example.com"
      fill_in "user[password]", with: user.password
      click_on("submit_sign_in")

      expect(page).to(have_content(I18n.t("devise.failure.invalid", locale: user.locale, authentication_keys: "Email")))
      expect(current_path).to(eq(new_user_session_path(user.locale)))
    end

    scenario "User sees an error message when password is incorrect" do
      visit new_user_session_path(locale: user.locale)
      fill_in "user[email]", with: user.email
      fill_in "user[password]", with: "wrongpassword"
      click_on("submit_sign_in")

      expect(page).to(have_content(I18n.t("devise.failure.invalid", locale: user.locale, authentication_keys: "Email")))
      expect(current_path).to(eq(new_user_session_path(locale: user.locale)))
    end
  end
end
