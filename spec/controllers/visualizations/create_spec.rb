require 'rails_helper'

RSpec.describe VisualizationsController, type: :controller do
  let(:user) { create(:user, :not_guest) }
  let(:valid_attributes) do
    attributes_for(:visualization).merge(
      image: fixture_file_upload(Rails.root.join('db/seeds/images/sample_1.png'), 'image/png')
    )
  end

  let(:invalid_attributes) do
    { user: nil, title: nil, description: nil, creation_date: nil, scale: nil, sources: nil, geographic_coverage: nil, projection: nil, category: nil }
  end

  before do
    sign_in(user)
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Visualization" do
        expect {
          post :create, params: { visualization: valid_attributes }
        }.to change(Visualization, :count).by(1)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Visualization" do
        expect {
          post :create, params: { visualization: invalid_attributes }
        }.not_to change(Visualization, :count)
      end
    end

    context "when unauthorized" do
      let(:user) { create(:user, :not_guest) }

      before do
        sign_in(user)
        allow_any_instance_of(VisualizationsController).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
      end

      it "redirects to the root path" do
        post :create, params: { visualization: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
