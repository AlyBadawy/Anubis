class Session < ApplicationRecord
  belongs_to :user

  validates :ip_address, presence: true
  validates :user_agent, presence: true
  validates :refresh_token, presence: true

  def revoke!
    update!(revoked: true)
  end

  def is_valid_session?
    !revoked && refresh_token_expires_at > Time.current
  end

  def refresh!
    raise Anubis::SessionErrors::SessionRevokedError, "Session is revoked" if revoked
    raise Anubis::SessionErrors::SessionExpiredError, "Session is expired" if refresh_token_expires_at < Time.current
    raise Anubis::SessionErrors::SessionInvalidError, "Session is invalid" unless is_valid_session?

    self.class.increment_counter(:refresh_count, id) # rubocop:disable Rails/SkipsModelValidations

    update!(refresh_token: SecureRandom.hex(64),
            last_refreshed_at: Time.current,
            refresh_token_expires_at: 1.week.from_now)
  end
end
