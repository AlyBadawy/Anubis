class AccountsController < ApplicationController
  def show
    @user = User.find_by(username: params.expect(:username))
    if @user
      render :show, status: :ok, location: @user
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end
end
