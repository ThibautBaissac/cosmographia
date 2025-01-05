require "rails_helper"

RSpec.describe ChallengesController, type: :controller do
  let(:user) { create(:user) }
  before do
    sign_in user
  end

  describe "GET #index" do
    context "when user is authorized" do
      before do
        allow(controller).to receive(:authorize).and_return(true)
        @challenges = create_list(:challenge, 5, start_date: Date.today)
      end

      it "responds successfully with HTTP 200 status" do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    context "when user is unauthorized" do
      before do
        allow(controller).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
      end

      it "returns a redirect status" do
        get :index
        expect(response).to have_http_status(:found) # 302
      end

      it "redirects to the homepage page" do
        get :index
        expect(response).to redirect_to(root_path(locale: :en))
      end
    end

    context "when user is unauthenticated" do
      before do
        sign_out user
      end

      it "redirects to the sign-in page" do
        get :index, params: { locale: "en" }
        expect(response).to redirect_to(new_user_session_path(locale: :en))
      end
    end
  end
end
