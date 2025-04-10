class ApplicationController < ActionController::API
  include Identity

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::ParameterMissing, with: :render_400

  private

  def render_404
    render status: :not_found, json: { error: "Record not found" }
  end

  def render_400(exception)
    render status: :bad_request, json: { error: exception.message }
  end
end
