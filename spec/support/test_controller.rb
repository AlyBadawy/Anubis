class TestController < ApplicationController
  include Identity
  skip_authentication! only: %i[not_found bad_request]

  def index
    render json: { message: "Success" }
  end

  def not_found
    raise ActiveRecord::RecordNotFound
  end

  def bad_request
    raise ActionController::ParameterMissing.new(:param)
  end
end
