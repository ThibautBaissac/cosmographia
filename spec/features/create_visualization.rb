require 'rails_helper'
require "support/base_feature_helper"

RSpec.feature("Create Visualization", type: :feature) do
  include BaseFeatureHelper

  let(:user) { create(:user, :with_free_subscription) }

  before do
    sign_in_as(email: user.email, password: user.password)
  end

  context "With remaining visualizations" do
    scenario "User creates new visualization successfully" do
      visit(visualizations_url(locale: user.locale))
      expect(page).to(have_selector("#visualizations_header"))

      click_on("create_visualization_title")
      expect(page).to(have_selector("#new_visualization_header"))
    end
  end
end
