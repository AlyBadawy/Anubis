require "rails_helper"

RSpec.describe "/profiles/", type: :request do
  describe "GET /:username" do
    context "when username exists" do
      it "renders a successful response" do
        username = create(:user).username
        get profile_by_username_url(username), as: :json, headers: @valid_headers
        expect(response).to be_successful
      end

      it "renders the user profile" do
        username = create(:user).username
        get profile_by_username_url(username), as: :json, headers: @valid_headers
        expect(response.content_type).to match(a_string_including("application/json"))
        res_body = JSON.parse(response.body)
        expected_keys = ["id", "first_name", "last_name", "phone", "username", "bio", "roles", "created_at", "updated_at", "url"]
        expect(res_body.keys).to include(*expected_keys)
        expect(res_body["username"]).to eq(username)
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
end
