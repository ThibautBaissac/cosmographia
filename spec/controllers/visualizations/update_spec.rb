require 'rails_helper'

RSpec.describe VisualizationsController, type: :controller do
  let(:user) { create(:user, :not_guest) }
  let(:visualization) { create(:visualization, user: user) }
  let(:new_valid_attributes) { attributes_for(:visualization) }
  let(:new_invalid_attributes) { {title: nil} }

  before do
    sign_in(user)
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the visualization and redirects to show page" do
        patch :update, params: { id: visualization.id, visualization: new_valid_attributes }

        expect(response).to have_http_status(:found)
      end
    end

    context "with invalid parameters" do
      it "does not update the new Visualization" do
        patch :update, params: { id: visualization.id, visualization: new_invalid_attributes }

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when unauthorized" do
      before do
        allow_any_instance_of(VisualizationsController).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
      end

      it "redirects to the root path" do
        patch :update, params: { id: visualization.id, visualization: new_valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
