require "rails_helper"

RSpec.describe Identity, type: :request do
  before do
    Rails.application.routes.draw do
      get "/test", to: "test#index"
    end
  end

  after do
    Rails.application.reload_routes!
  end

  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:valid_headers) {
    token = JwtHelper.encode(session)
    { "Authorization" => "Bearer #{token}" }
  }

  describe "GET /test" do
    context "with a valid token" do
      it "returns a successful response" do
        get "/test", headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("message" => "Success")
      end
    end

    context "with an invalid token" do
      it "returns an unauthorized response" do
        get "/test", headers: { "Authorization" => "Bearer invalid.token" }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns JSON error message of Invalid encoding" do
        get "/test", headers: { "Authorization" => "Bearer invalid token" }, as: :json

        expect(JSON.parse(response.body)).to include("error" => "Invalid token: Invalid segment encoding")
      end
    end

    context "with a missing token" do
      it "returns an unauthorized response" do
        get "/test", as: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns JSON error message of Missing or invalid Authorization header" do
        get "/test", as: :json
        expect(JSON.parse(response.body)).to include("error" => "Missing or invalid Authorization header")
      end
    end
  end
end
