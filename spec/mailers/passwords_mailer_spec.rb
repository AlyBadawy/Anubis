require "rails_helper"
RSpec.describe PasswordsMailer, type: :mailer do
  describe "#reset" do
    let (:user) { create(:user) }
    let (:mail) { described_class.reset(user) }

    it "renders the correct headers [to, from, subject]" do
      expect(mail.subject).to eq("Reset your password")
      expect(mail.to).to eq([user.email_address])
      expect(mail.from).to eq(["no-reply@example.com"])
    end

    it "renders the mail message body" do
      expect(mail.body.encoded).to match("You can reset your password within the next 15 minutes on")
    end
  end
end
