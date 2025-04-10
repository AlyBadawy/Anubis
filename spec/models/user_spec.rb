require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:email_address) }
    it { is_expected.to validate_length_of(:email_address).is_at_least(5) }
    it { is_expected.to validate_length_of(:email_address).is_at_most(255) }
    it { is_expected.to validate_uniqueness_of(:email_address).case_insensitive }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to validate_length_of(:username).is_at_most(20) }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_length_of(:first_name).is_at_most(50) }

    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_length_of(:last_name).is_at_most(50) }

    it { is_expected.to validate_length_of(:phone).is_at_most(15) }

    it { is_expected.to validate_length_of(:bio).is_at_most(1000) }
  end

  describe "normalizations" do
    it "normalizes email address" do
      user = build(:user)
      user.email_address = " Test@Example.COM "
      user.valid?
      expect(user.email_address).to eq("test@example.com")
    end
  end

  describe "password encryption" do
    it "encrypts the password" do
      user = described_class.create(email_address: "test@example.com", password: "password", password_confirmation: "password")
      expect(user.password_digest).not_to eq("password")
    end
  end

  describe "authentication" do
    it "has secure password" do
      user = build(:user)
      expect(user).to respond_to(:authenticate)
    end

    it "authenticate user by password" do
      user = FactoryBot.create(:user, password: "secure_password", password_confirmation: "secure_password")
      expect(described_class.authenticate_by(email_address: user.email_address, password: "invalid_password")).to be_nil
      expect(described_class.authenticate_by(email_address: user.email_address, password: "secure_password")).to eq(user)
    end
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:user)).to be_valid
    end
  end

  describe "Associations" do
    it { is_expected.to have_many(:role_assignments).dependent(:destroy) }
    it { is_expected.to have_many(:roles).through(:role_assignments) }
    it { is_expected.to have_many(:sessions).dependent(:destroy) }
  end
end
