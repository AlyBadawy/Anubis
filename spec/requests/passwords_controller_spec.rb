require "rails_helper"

RSpec.describe PasswordsController, type: :request do
  describe "/passwords" do
    describe "POST /forgot" do
      it "Always shows a successful response" do
        post forgot_password_url, params: { email_address: @signed_in_user.email_address }
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to eq(
          {
            "message" => "Password reset instructions sent (if user with that email address exists).",
          }
        )
      end

      context "when the user exists" do
        it "Send an email" do
          allow(PasswordsMailer).to receive(:reset).and_call_original
          post forgot_password_url, params: { email_address: @signed_in_user.email_address }
          expect(PasswordsMailer).to have_received(:reset).with(@signed_in_user).exactly(1)
        end
      end

      context "when the user doesn't exist" do
        it "Doesn't send an email" do
          allow(PasswordsMailer).to receive(:reset).and_call_original
          post forgot_password_url, params: { email_address: "wrong@email.com" }
          expect(PasswordsMailer).to have_received(:reset).with(@signed_in_user).exactly(0)
        end
      end
    end

    describe "PUT /passwords" do
      context "when Correct token for a user is provided" do
        it "renders a successful response" do
          token = @signed_in_user.password_reset_token
          put reset_password_url, params: {
                                    password_reset_token: token,
                                    password: "new_password",
                                    password_confirmation: "new_password",
                                  }
          expect(response).to be_successful
        end

        it "resets the password when password is valid" do
          expect(
            User.authenticate_by(
              email_address: @signed_in_user.email_address,
              password: "new_password",
            )
          ).to be_nil
          token = @signed_in_user.password_reset_token
          put reset_password_url, params: {
                                    password_reset_token: token,
                                    password: "new_password",
                                    password_confirmation: "new_password",
                                  }
          expect(JSON.parse(response.body)).to eq(
            { "message" => "Password has been reset." }
          )
          expect(
            User.authenticate_by(
              email_address: @signed_in_user.email_address,
              password: "new_password",
            )
          ).to eq(@signed_in_user)
        end

        it "doesn't reset the password when password_confirmation is blank" do
          expect(
            User.authenticate_by(
              email_address: @signed_in_user.email_address,
              password: "new_password",
            )
          ).to be_nil
          token = @signed_in_user.password_reset_token
          put reset_password_url, params: {
                                    password_reset_token: token,
                                    password: "new_password",
                                  }
          expect(JSON.parse(response.body)).to eq(
            { "error" => "param is missing or the value is empty or invalid: password_confirmation" }
          )
          expect(
            User.authenticate_by(
              email_address: @signed_in_user.email_address,
              password: "new_password",
            )
          ).to be_nil
        end

        it "doesn't reset the password when password is invalid" do
          expect(
            User.authenticate_by(
              email_address: @signed_in_user.email_address,
              password: "new_password",
            )
          ).to be_nil
          token = @signed_in_user.password_reset_token
          put reset_password_url, params: {
                                    password_reset_token: token,
                                    password: "new_password",
                                    password_confirmation: "incorrect",
                                  }
          expect(JSON.parse(response.body)).to eq(
            { "errors" => { "password_confirmation" => ["doesn't match Password"] } }
          )
          expect(
            User.authenticate_by(
              email_address: @signed_in_user.email_address,
              password: "new_password",
            )
          ).to be_nil
        end
      end

      context "when Incorrect token for a user is provided" do
        it "renders a unprocessable_entity response" do
          put reset_password_url,
              params: {
                password_reset_token: "invalid_token",
                password: "new_password",
                password_confirmation: "new_password",
              }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to eq(
            { "errors" => { "password_reset_token" => "is invalid or has expired" } }
          )
        end

        it "Doesn't reset the password" do
          expect(
            User.authenticate_by(
              email_address: @signed_in_user.email_address,
              password: "password",
            )
          ).to eq(@signed_in_user)
          put reset_password_url,
              params: {
                password_reset_token: "invalid_token",
                password: "new_password",
                password_confirmation: "new_password",
              }
          expect(
            User.authenticate_by(
              email_address: @signed_in_user.email_address,
              password: "new_password",
            )
          ).to be_nil

          expect(
            User.authenticate_by(
              email_address: @signed_in_user.email_address,
              password: "password",
            )
          ).to eq(@signed_in_user)
        end
      end
    end
  end
end
