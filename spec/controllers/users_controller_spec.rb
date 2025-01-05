require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  before do
  end

  describe "GET #show" do
    context "when user is authorized" do
      before do
        sign_in user
        allow(controller).to receive(:authorize).and_return(true)
      end

      it "responds successfully with HTTP 200 status" do
        get :show, params: { slug: user.slug }
        expect(response).to have_http_status(:ok)
      end
    end

    context "when user is unauthorized" do
      before do
        sign_in user
        allow(controller).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
      end

      it "returns a redirect status" do
        get :show, params: { slug: user.slug }
        expect(response).to have_http_status(:found) # 302
      end

      it "redirects to the homepage page" do
        get :show, params: { slug: user.slug }
        expect(response).to redirect_to(root_path(locale: :en))
      end
    end

    context "when user does not exist" do
      before do
        allow(controller).to receive(:authorize).and_return(true)
      end

      it "returns a not found status" do
        get :show, params: { slug: "non-existent-user", locale: :en }
        expect(response).to have_http_status(:found) # 302
      end

      it "redirects to the homepage page" do
        get :show, params: { slug: "non-existent-user", locale: :en }
        expect(response).to redirect_to(root_path(locale: :en))
      end
    end
  end
end
