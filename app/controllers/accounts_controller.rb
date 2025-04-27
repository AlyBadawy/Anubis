class AccountsController < ApplicationController
  def me
    @user = Current.user

    render :show, status: :ok, location: @user
  end

  def show
    @user = User.find_by(username: params.expect(:username))
    render_user_profile
  end

  def register
    @user = User.new(user_params)
    if @user.save
      render :show, status: :created, location: @user
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_profile
    @user = Current.user
    if @user.authenticate(params[:user][:current_password])
      if @user.update(user_params)
        render :show, status: :ok, location: @user
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Current password is incorrect" }, status: :unprocessable_entity
    end
  end

  def delete_account
    @user = Current.user
    if @user.authenticate(params[:user][:current_password])
      @user.destroy
      render json: { message: "Account deleted successfully" }, status: :ok
    else
      render json: { error: "Current password is incorrect" }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.expect(user: [:email_address, :password, :password_confirmation, :first_name, :last_name, :phone, :username, :bio])
  end

  def render_user_profile
    if @user
      render :show, status: :ok, location: @user
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end
end
