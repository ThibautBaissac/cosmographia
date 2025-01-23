require 'rails_helper'

RSpec.describe(FeedbacksController, type: :controller) do
  let(:user) { create(:user) }
  let(:valid_attributes) { attributes_for(:feedback) }
  let(:invalid_attributes) { {subject: nil, message: nil} }

  before do
    sign_in user
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new feedback and redirects to root path" do
        allow_any_instance_of(FeedbackPolicy).to(receive(:create?).and_return(true))

        expect {
          post(:create, params: {feedback: valid_attributes})
        }.to(change(Feedback, :count).by(1))

        expect(response).to(redirect_to(root_path(I18n.locale)))
      end
    end

    context "with invalid params" do
      it "does not create a feedback and redirects to root path" do
        allow_any_instance_of(FeedbackPolicy).to(receive(:create?).and_return(true))

        expect {
          post(:create, params: {feedback: invalid_attributes})
        }.not_to(change(Feedback, :count))

        expect(response).to(redirect_to(root_path(I18n.locale)))
      end
    end

    context "when unauthorized" do
      it "does not create feedback and redirects" do
        allow_any_instance_of(FeedbackPolicy).to(receive(:create?).and_return(false))

        expect {
          post(:create, params: {feedback: valid_attributes})
        }.not_to(change(Feedback, :count))

        expect(response).to(redirect_to(root_path(I18n.locale)))
      end
    end
  end
end
