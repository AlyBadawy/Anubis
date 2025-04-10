require "rails_helper"
RSpec.describe Session, type: :model do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:ip_address) }
    it { is_expected.to validate_presence_of(:user_agent) }
    it { is_expected.to validate_presence_of(:refresh_token) }
  end

  describe "#revoke!" do
    it "sets revoked to true" do
      session.revoke!
      expect(session.reload.revoked).to be true
    end
  end

  describe "#is_valid_session?" do
    context "when the session is not revoked and not expired" do
      it "returns true" do
        expect(session.is_valid_session?).to be true
      end
    end

    context "when the session is revoked" do
      it "returns false" do
        session.revoke!
        expect(session.is_valid_session?).to be false
      end
    end

    context "when the session is expired" do
      it "returns false" do
        session.update!(refresh_token_expires_at: 1.minute.ago)
        expect(session.is_valid_session?).to be false
      end
    end
  end

  describe "#refresh!" do
    it "updates last_refreshed_at and increments refresh_count" do
      expect {
        session.refresh!
      }.to change { session.reload.last_refreshed_at }.and change { session.reload.refresh_count }.by(1)
    end
  end
end
