require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #index" do
    context "when user is signed in" do
      before do
        sign_in user

        visualizations = create_list(:visualization, 15, user: user)
        create_list(:visualization_comment, 5, visualization: visualizations.last, user: user)
        software_a, software_b = create(:software, name: "Software A"), create(:software, name: "Software B")
        create(:visualization_software, software: software_a, visualization: visualizations.first)
        create(:visualization_software, software: software_b, visualization: visualizations.second)

        get :index
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not signed in" do
      before do
        Rails.cache.delete("homepage/signed_out/visualizations")
        allow(Visualizations::DailyRandom).to receive(:new).and_return(double(call: create_list(:visualization, 6)))
        get :index
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end
    end

    context "handling cache expiration and service failure" do
      before { sign_in user }

      it "handles cache fetch failure gracefully" do
        allow(Rails.cache).to receive(:fetch).and_raise(StandardError, "Cache Error")

        expect { get :index }.not_to raise_error
        expect(response).to have_http_status(:success)
      end
    end
  end
end
