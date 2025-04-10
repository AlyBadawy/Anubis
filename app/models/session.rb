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
    update!(last_refreshed_at: Time.current, refresh_count: self.refresh_count + 1)
  end
end
