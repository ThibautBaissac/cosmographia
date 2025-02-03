require "rails_helper"

RSpec.describe(VisualizationsController, type: :controller) do
  let(:user) { create(:user) }
  let(:visualization) { create(:visualization) }

  before do
    sign_in user
  end

  describe "GET #show" do
    context "when user is authorized" do
      before do
        allow(controller).to(receive(:authorize).and_return(true))
      end

      it "responds successfully with HTTP 200 status" do
        get :show, params: {id: visualization.id}
        expect(response).to(have_http_status(:ok))
      end
    end
  end
end
