require "rails_helper"

RSpec.describe "/admin/roles", type: :request do
  let(:valid_attributes) {
    {
      role_name: "Admin",
      hide_from_profile: true,
    }
  }

  let(:invalid_attributes) {
    { role_name: nil }
  }

  describe "GET /index" do
    it "renders a successful response" do
      Role.create! valid_attributes
      get roles_url, headers: @valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      role = Role.create! valid_attributes
      get role_url(role), as: :json, headers: @valid_headers
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Role" do
        expect {
          post roles_url,
               params: { role: valid_attributes }, headers: @valid_headers, as: :json
        }.to change(Role, :count).by(1)
      end

      it "renders a JSON response with the new role" do
        post roles_url,
             params: { role: valid_attributes }, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        res_body = JSON.parse(response.body)
        expect(res_body["role_name"]).to eq("Admin")
        expect(res_body["hide_from_profile"]).to be(true)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Role" do
        expect {
          post roles_url,
               params: { role: invalid_attributes }, as: :json
        }.not_to change(Role, :count)
      end

      it "renders a JSON response with errors for the new role" do
        post roles_url,
             params: { role: invalid_attributes }, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          role_name: "User",
          hide_from_profile: false,
        }
      }

      it "updates the requested role" do
        role = Role.create! valid_attributes
        patch role_url(role),
              params: { role: new_attributes }, headers: @valid_headers, as: :json
        role.reload
        expect(role.role_name).to eq("User")
        expect(role.hide_from_profile).to be(false)
      end

      it "renders a JSON response with the role" do
        role = Role.create! valid_attributes
        patch role_url(role),
              params: { role: new_attributes }, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the role" do
        role = Role.create! valid_attributes
        patch role_url(role),
              params: { role: invalid_attributes }, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested role" do
      role = Role.create! valid_attributes
      expect {
        delete role_url(role), headers: @valid_headers, as: :json
      }.to change(Role, :count).by(-1)
    end
  end
end
