require "rails_helper"

RSpec.describe "/profiles/", type: :request do
  let(:valid_attributes) {
    {
      email_address: "test@example.com",
      password: "password",
      password_confirmation: "password",
      username: "test",
      first_name: "Test",
      last_name: "User",
      phone: "1234567890",
      bio: "Test user",
    }
  }

  let(:invalid_attributes) {
    {
      email_address: "test@example.com",
      password: "password",
      password_confirmation: "invalid",
    }
  }

  let(:valid_headers) {
    {}
  }

  describe "GET /:username" do
    context "when username exists" do
      it "renders a successful response" do
        create(:user, username: "testUser")
        get profile_by_username_url("testUser"), as: :json, headers: @valid_headers
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response).to be_successful
      end

      it "renders the user profile" do
        create(:user, username: "testUser2")
        get profile_by_username_url("testUser2"), as: :json, headers: @valid_headers
        res_body = JSON.parse(response.body)
        expected_keys = ["id", "first_name", "last_name", "phone", "username", "bio", "roles", "created_at", "updated_at", "url"]
        expect(res_body.keys).to include(*expected_keys)
        expect(res_body["username"]).to eq("testUser2")
        expect(res_body["roles"]).to be_an(Array)
        expect(res_body["roles"].length).to eq(0)
      end
    end

    context "when username does not exist" do
      let(:username) { "non_existent_username" }

      it "renders a not found response" do
        get profile_by_username_url(username), as: :json, headers: @valid_headers
        expect(response).to have_http_status(:not_found)
      end

      it "renders an error message" do
        get profile_by_username_url(username), as: :json, headers: @valid_headers
        expect(response.content_type).to match(a_string_including("application/json"))
        res_body = JSON.parse(response.body)
        expect(res_body["error"]).to eq("User not found")
      end

      it "does not render the user profile" do
        get profile_by_username_url(username), as: :json, headers: @valid_headers
        expect(response.content_type).to match(a_string_including("application/json"))
        res_body = JSON.parse(response.body)
        expected_keys = ["error"]
        expect(res_body.keys).to include(*expected_keys)
        expect(res_body["error"]).to eq("User not found")
      end
    end
  end

  describe "POST /register" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post register_url,
               params: { user: valid_attributes }, headers: valid_headers, as: :json
        }.to change(User, :count).by(1)
      end

      it "renders a JSON response with the new user" do
        post register_url,
             params: { user: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post register_url,
               params: { user: invalid_attributes }, as: :json
        }.not_to change(User, :count)
      end

      it "renders a JSON response with errors for the new user" do
        post register_url,
             params: { user: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end
end
