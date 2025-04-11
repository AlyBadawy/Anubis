module Identity
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  class_methods do
    def skip_authentication!(**options)
      skip_before_action :authenticate_user!, **options
    end
  end

  private

  def authenticate_user!
    authenticated = AuthenticationHelper.authenticate!(request)
    unless authenticated
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def start_new_session_for(user)
    user.sessions.create!(
      user_agent: request.user_agent,
      ip_address: request.remote_ip,
      refresh_token: SecureRandom.hex(64),
      last_refreshed_at: Time.current,
      refresh_token_expires_at: 1.week.from_now,
    ).tap do |session|
      Current.session = session
    end
  end

  def create_jwt_for_current_session
    JwtHelper.encode(Current.session)
  end
end
