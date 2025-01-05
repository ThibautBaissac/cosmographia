require 'rails_helper'

RSpec.describe ChallengesController, type: :controller do
  let(:user) { create(:user, :superadmin) }
  let(:valid_attributes) { attributes_for(:challenge) }

  let(:invalid_attributes) do
    { title: "", start_date: nil, end_date: nil, description: "", difficulty: nil, category: nil }
  end

  before do
    sign_in(user)
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Challenge and redirects to the show page" do
          expect {
            post :create, params: { challenge: valid_attributes }
          }.to change(Challenge, :count).by(1)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Challenge" do
        expect {
          post :create, params: { challenge: invalid_attributes }
        }.not_to change(Challenge, :count)
      end
    end

    context "when unauthorized" do
      let(:user) { create(:user, :not_guest) }

      before do
        sign_in(user)
        allow_any_instance_of(ChallengesController).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
      end

      it "redirects to the root path" do
        post :create, params: { challenge: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
