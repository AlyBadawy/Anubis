class PasswordsController < ApplicationController
  skip_authentication!
  before_action :set_user_by_password_token, only: %i[ reset_password ]

  def forgot_password
    if user = User.find_by(email_address: params.require(:email_address))
      PasswordsMailer.reset(user).deliver_later
    end

    render status: :ok, json: { message: "Password reset instructions sent (if user with that email address exists)." }
  end

  def reset_password
    if params.require(:password_confirmation) && @user.update(params.permit(:password, :password_confirmation))
      render status: :ok, json: { message: "Password has been reset." }
    else
      render status: :unprocessable_entity, json: { errors: @user.errors }
    end
  end

  private

  def set_user_by_password_token
    @user = User.find_by_password_reset_token!(params[:password_reset_token]) # rubocop:disable Rails/DynamicFindBy
  rescue ActiveSupport::MessageVerifier::InvalidSignature, ActiveRecord::RecordNotFound
    render status: :unprocessable_entity, json: { errors: { password_reset_token: "is invalid or has expired" } }
  end
end
