module Anubis
  module SessionErrors
    class SessionRevokedError < StandardError; end
    class SessionExpiredError < StandardError; end
    class SessionInvalidError < StandardError; end
  end
end
