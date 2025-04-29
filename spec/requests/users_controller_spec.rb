require "rails_helper"

RSpec.describe UsersController, type: :request do
  describe "/admin/users" do
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

    let(:expected_keys) {
      %w[
        id first_name last_name phone username bio roles created_at updated_at url
      ]
    }

    describe "GET /index" do
      it "renders a successful response" do
        User.create! valid_attributes
        get users_url, headers: @valid_headers, as: :json
        expect(response).to be_successful
      end

      it "renders a JSON response with all users as an array" do
        get users_url, headers: @valid_headers, as: :json
        expect(response.content_type).to match(a_string_including("application/json"))
        res_body = JSON.parse(response.body)
        expect(res_body).to be_an(Array)
        expect(res_body.length).to eq(1)
        expect(res_body[0]["username"]).to eq(@signed_in_user.username)
      end
    end

    describe "GET /show" do
      it "renders a successful response" do
        user = User.create! valid_attributes
        get user_url(user), headers: @valid_headers, as: :json
        expect(response).to be_successful
      end

      it "renders a JSON response of the user with correct keys" do
        user = User.create! valid_attributes
        get user_url(user), headers: @valid_headers, as: :json
        expect(response.content_type).to match(a_string_including("application/json"))
        res_body = JSON.parse(response.body)
        expect(res_body.keys).to include(*expected_keys)
      end

      it "doesn't render the email address in the user object (for privacy)" do
        user = User.create! valid_attributes
        get user_url(user), headers: @valid_headers, as: :json
        response_body = JSON.parse(response.body)
        expect(response_body.keys).not_to include("email_address")
      end

      it "doesn't renders password_digest in the user object" do
        user = User.create! valid_attributes
        get user_url(user), headers: @valid_headers, as: :json
        response_body = JSON.parse(response.body)
        expect(response_body.keys).not_to include("password_digest")
        expect(response_body.keys).to include(*expected_keys)
      end
    end

    describe "POST /create" do
      context "with valid parameters" do
        it "creates a new User" do
          expect {
            post users_url,
                 params: { user: valid_attributes }, headers: @valid_headers, as: :json
          }.to change(User, :count).by(1)
        end

        it "renders a JSON response with the new user" do
          post users_url,
               params: { user: valid_attributes }, headers: @valid_headers, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid parameters" do
        it "does not create a new User" do
          expect {
            post users_url,
                 params: { user: invalid_attributes }, as: :json
          }.not_to change(User, :count)
        end

        it "renders a JSON response with errors for the new user" do
          post users_url,
               params: { user: invalid_attributes }, headers: @valid_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end

    describe "PATCH /update" do
      context "with valid parameters" do
        let(:new_attributes) {
          {
            username: "John.doe",
            first_name: "John",
            last_name: "Doe",
            phone: "1234567891",
            bio: "John Doe is the best!",
          }
        }

        it "updates the requested user" do
          user = User.create! valid_attributes
          patch user_url(user),
                params: { user: new_attributes }, headers: @valid_headers, as: :json
          user.reload
          expect(user).to have_attributes(new_attributes)
        end

        it "renders a JSON response with the user" do
          user = User.create! valid_attributes
          patch user_url(user),
                params: { user: new_attributes }, headers: @valid_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid parameters" do
        it "renders a JSON response with errors for the user" do
          user = User.create! valid_attributes
          patch user_url(user),
                params: { user: invalid_attributes }, headers: @valid_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end

    describe "DELETE /destroy" do
      it "destroys the requested user" do
        user = User.create! valid_attributes
        expect {
          delete user_url(user), headers: @valid_headers, as: :json
        }.to change(User, :count).by(-1)
      end

      it "returns a 204 no content response" do
        user = User.create! valid_attributes
        delete user_url(user), headers: @valid_headers, as: :json
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
