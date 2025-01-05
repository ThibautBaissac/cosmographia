require 'rails_helper'

RSpec.describe AboutController, type: :controller do
  describe "GET #index" do
    it "responds successfully without authentication" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
