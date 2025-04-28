require "rails_helper"

RSpec.describe SessionsController, type: :request do
  describe "/sessions" do
    describe "GET '/'" do
      it "lists all sessions for the current user" do
        create(:session, user: @signed_in_user)
        get index_sessions_url, headers: @valid_headers, as: :json
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to be_an_instance_of(Array)
        expect(JSON.parse(response.body).first).to include(
          "id",
          "refresh_count",
          "refresh_token",
          "refresh_token_expires_at",
          "last_refreshed_at",
          "revoked"
        )
      end

      it "return 401 unauthorized when no valid headers" do
        get index_sessions_url, as: :json
        expect(response).not_to be_successful
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "GET '/current'" do
      it "shows the session for current session (get session)" do
        get current_session_url, headers: @valid_headers, as: :json
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to include(
          "id",
          "refresh_count",
          "refresh_token",
          "refresh_token_expires_at",
          "last_refreshed_at",
          "revoked"
        )
      end

      it "return 401 unauthorized when no valid headers" do
        get current_session_url, as: :json
        expect(response).not_to be_successful
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "GET '/id/:id'" do
      it "shows the session for a given ID (get sessions/:id)" do
        new_session = create(:session, user: @signed_in_user)
        get session_url(new_session), headers: @valid_headers, as: :json
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to include(
          "id",
          "refresh_count",
          "refresh_token",
          "refresh_token_expires_at",
          "last_refreshed_at",
          "revoked"
        )
      end

      it "shows 404 not found for the wrong session ID (get sessions/:id)" do
        get session_url("wrong"), headers: @valid_headers, as: :json
        expect(response).not_to be_successful
        expect(response).to have_http_status(:not_found)
      end
    end

    describe "POST '/login'" do
      let(:new_user) { create(:user, password: "password") }
      let(:new_session) { create(:session, user: new_user) }
      let(:new_valid_headers) {
        token = JwtHelper.encode(new_session)
        { "Authorization" => "Bearer #{token}" }
      }
      let(:valid_attributes) {
        { email_address: new_user.email_address, password: "password" }
      }

      let(:invalid_attributes) {
        { email_address: new_user.email_address, password: "wrong_password" }
      }

      context "with valid parameters" do
        it "signs in the user and returns tokens" do
          headers = { "User-Agent" => "RSpec" }
          post login_url, params: valid_attributes, headers: headers, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(response.body).to include(
            "access_token",
            "refresh_token",
            "refresh_token_expires_at"
          )
        end
      end

      context "with invalid parameters" do
        it "returns unauthorized status" do
          headers = { "User-Agent" => "RSpec" }
          post login_url, params: invalid_attributes, headers: headers, as: :json
          expect(response).to have_http_status(:unauthorized)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(response.body).to include("error")
        end
      end
    end

    describe "DELETE '/logout'" do
      it "logs out the current user" do
        Current.session = @signed_in_session
        expect(Current.session).not_to be_nil
        delete logout_url, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:no_content)
        expect(Current.session).to be_nil
      end

      it "returns 401 unauthorized when no valid headers" do
        delete logout_url, as: :json
        expect(response).not_to be_successful
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "PUT /refresh" do
      it "refreshes the session" do
        Current.session = @signed_in_session
        expect(Current.session).not_to be_nil
        put refresh_session_url, params: { refresh_token: @signed_in_session.refresh_token }, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.body).to include(
          "access_token",
          "refresh_token",
          "refresh_token_expires_at"
        )
      end

      it "returns 422 unprocessable entity when session is invalid" do
        Current.session = @signed_in_session
        Current.session.revoke!
        put refresh_session_url, params: { refresh_token: @signed_in_session.refresh_token }, headers: @valid_headers, as: :json
        expect(response).not_to be_successful
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe "DELETE /revoke" do
      it "revokes the current session" do
        Current.session = @signed_in_session
        expect(Current.session).not_to be_nil
        delete revoke_session_url, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:no_content)
        expect(Current.session).to be_nil
      end

      it "returns 401 unauthorized when no valid headers" do
        delete revoke_session_url, as: :json
        expect(response).not_to be_successful
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns 404 not found when session ID is invalid" do
        Current.session = @signed_in_session
        expect(Current.session).not_to be_nil
        delete revoke_session_url(id: "invalid"), headers: @valid_headers, as: :json
        expect(response).not_to be_successful
        expect(response).to have_http_status(:not_found)
      end

      it "returns 401 unauthorized when session is already revoked" do
        Current.session = @signed_in_session
        expect(Current.session).not_to be_nil
        Current.session.revoke!
        delete revoke_session_url, headers: @valid_headers, as: :json
        expect(response).not_to be_successful
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "DELETE /revoke_all" do
      it "revokes all sessions for the current user" do
        Current.session = @signed_in_session
        expect(Current.session).not_to be_nil
        delete revoke_all_sessions_url, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:no_content)
        expect(Current.session).to be_nil
      end

      it "returns 401 unauthorized when no valid headers" do
        delete revoke_all_sessions_url, as: :json
        expect(response).not_to be_successful
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
