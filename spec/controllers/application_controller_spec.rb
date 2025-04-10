require "rails_helper"

RSpec.describe ApplicationController, type: :request do
  before do
    Rails.application.routes.draw do
      get "/test/not_found", to: "test#not_found"
      get "/test/bad_request", to: "test#bad_request"
    end
  end

  after do
    Rails.application.reload_routes!
  end

  describe "GET /test/not_found" do
    it "returns a 404 not found response" do
      get "/test/not_found", as: :json
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to include("error" => "Record not found")
    end
  end

  describe "GET /test/bad_request" do
    it "returns a 400 bad request response" do
      get "/test/bad_request", as: :json
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to include(
        "error" => "param is missing or the value is empty or invalid: param",
      )
    end
  end
end
