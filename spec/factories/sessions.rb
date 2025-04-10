FactoryBot.define do
  factory :session do
    ip_address { "127.0.0.1" }
    user_agent { "RSpec" }
    refresh_count { 1 }
    refresh_token { SecureRandom.hex(64) }
    last_refreshed_at { Time.current }
    refresh_token_expires_at { 1.week.from_now }
    revoked { false }
    association :user
  end
end
