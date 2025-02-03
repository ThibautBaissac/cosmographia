require "rails_helper"

RSpec.describe(VisualizationsController, type: :controller) do
  let(:user) { create(:user) }
  before do
    sign_in user
  end

  describe "GET #index" do
    context "when user is authorized" do
      before do
        allow(controller).to(receive(:authorize).and_return(true))
        @visualizations = create_list(:visualization, 5)
      end

      it "responds successfully with HTTP 200 status" do
        get :index
        expect(response).to(have_http_status(:ok))
      end
    end
  end
end
