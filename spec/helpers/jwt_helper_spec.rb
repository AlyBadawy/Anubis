require "rails_helper"

RSpec.describe JwtHelper, type: :helper do
  let(:session) { create(:session) }

  describe ".encode" do
    context "with a valid session" do
      it "returns a JWT token" do
        token = described_class.encode(session)
        expect(token).not_to be_nil
        expect(token).to be_a(String)
      end
    end

    context "with an invalid session" do
      it "returns nil" do
        token = described_class.encode(nil)
        expect(token).to be_nil
      end
    end
  end

  describe ".decode" do
    context "with a valid token" do
      it "returns the decoded payload" do
        token = described_class.encode(session)
        decoded_payload = described_class.decode(token)
        expect(decoded_payload).to include(
          "jti" => session.id,
          "exp" => be_within(1.second).of(3.minutes.from_now.to_i),
          "sub" => "session-access-token",
          "refresh_count" => session.refresh_count,
          "ip" => session.ip_address,
          "agent" => session.user_agent,
        )
      end
    end

    context "with an invalid token" do
      it "raises a JWT::DecodeError" do
        expect {
          described_class.decode("invalid.token")
        }.to raise_error(JWT::DecodeError)
      end
    end

    context "with an expired token" do
      it "raises a JWT::ExpiredSignature" do
        expired_session = create(:session)
        expired_token = described_class.encode(expired_session)
        travel_to 4.minutes.from_now do
          expect {
            described_class.decode(expired_token)
          }.to raise_error(JWT::ExpiredSignature)
        end
      end
    end
  end
end
