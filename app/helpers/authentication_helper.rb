module AuthenticationHelper
  def self.authenticate!(request)
    auth_header = request.headers["Authorization"]
    if auth_header.present? && auth_header.start_with?("Bearer ")
      token = auth_header.split(" ").last
      begin
        decoded_token = JwtHelper.decode(token)
        Current.session = Session.find_by!(id: decoded_token["jti"], revoked: false)
        true
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        false
      end
    else
      false
    end
  end
end
