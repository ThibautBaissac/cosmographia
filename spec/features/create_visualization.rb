require 'rails_helper'
require "support/base_feature_helper"

RSpec.feature("Create Visualization", type: :feature) do
  include BaseFeatureHelper

  let(:user) { create(:user, :with_free_subscription) }
  let(:visualization_title) { "MyDataVisualization" }

  before do
    sign_in_as(email: user.email, password: user.password)
  end

  context "With remaining visualizations" do
    scenario "User creates new visualization successfully" do
      visit(visualizations_url(locale: user.locale))
      expect(page).to(have_selector("#visualizations_header"))

      click_on("create_visualization_title")
      expect(page).to(have_selector("#new_visualization_header"))

      fill_in_visualization_form
      expect(page).to(have_content(visualization_title))
    end
  end

  private

  def fill_in_visualization_form
    within("#visualization_form") do
      choose("visualization_category_data")
      fill_in("visualization[title]", with: visualization_title)
      fill_in("visualization[creation_date]", with: 1.day.ago.strftime("%d/%m/%Y"))
      fill_in("visualization[description]", with: "Description")
      attach_file("visualization[image]", Rails.root.join("spec/fixtures/sample_1.jpg"))
      click_on("commit")
    end
  end
end
