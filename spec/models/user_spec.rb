require "rails_helper"

RSpec.describe User, type: :model do
  describe "factory" do
    it "has a valid factory" do
      expect(build(:user)).to be_valid
    end
  end

  describe "validations" do
    subject { build(:user) }

    describe "Email Address Validations" do
      it { is_expected.to validate_presence_of(:email_address) }
      it { is_expected.to validate_length_of(:email_address).is_at_least(5) }
      it { is_expected.to validate_length_of(:email_address).is_at_most(255) }
      it { is_expected.to validate_uniqueness_of(:email_address).case_insensitive }
    end

    describe "Username Validations" do
      it { is_expected.to validate_presence_of(:username) }

      it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
      it { is_expected.to validate_length_of(:username).is_at_most(20) }
    end

    describe "Username Format Validations" do
      it { is_expected.to allow_value("valid_username").for(:username) }
      it { is_expected.to allow_value("valid.username").for(:username) }
      it { is_expected.to allow_value("valid_username123").for(:username) }
      it { is_expected.to allow_value("valid_username_123").for(:username) }
      it { is_expected.to allow_value("valid.username_123").for(:username) }
      it { is_expected.not_to allow_value("123username").for(:username) }
      it { is_expected.not_to allow_value("valid__username").for(:username) }
      it { is_expected.not_to allow_value("valid..username").for(:username) }
      it { is_expected.not_to allow_value("valid__username.").for(:username) }
      it { is_expected.not_to allow_value("valid.username__").for(:username) }
      it { is_expected.not_to allow_value("valid.username__123").for(:username) }
      it { is_expected.not_to allow_value("valid.username__123_").for(:username) }
      it { is_expected.not_to allow_value("valid.username__123.").for(:username) }
      it { is_expected.not_to allow_value("valid.username__123_456").for(:username) }
      it { is_expected.not_to allow_value("valid.username__123_456.").for(:username) }
      it { is_expected.not_to allow_value("valid.username__123_456_").for(:username) }
      it { is_expected.not_to allow_value("valid.username__123_456_789").for(:username) }
    end

    describe "First/Last name validations" do
      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_length_of(:first_name).is_at_most(50) }

      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to validate_length_of(:last_name).is_at_most(50) }
    end

    describe "Other validations" do
      it { is_expected.to validate_length_of(:phone).is_at_most(15) }

      it { is_expected.to validate_length_of(:bio).is_at_most(1000) }
    end
  end

  describe "Associations" do
    it { is_expected.to have_many(:role_assignments).dependent(:destroy) }
    it { is_expected.to have_many(:roles).through(:role_assignments) }
    it { is_expected.to have_many(:sessions).dependent(:destroy) }
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
      my_user = described_class.create(email_address: "test@example.com", password: "password", password_confirmation: "password", username: "testUser", first_name: "Test", last_name: "User")
      my_user.reload
      expect(my_user.password_digest).not_to eq("password")
    end

    it "does not store the password in plain text" do
      my_user = described_class.create(email_address: "test3@example.com", password: "password", password_confirmation: "password", username: "testUser", first_name: "Test", last_name: "User")

      loaded_user = described_class.find(my_user.id)
      expect(loaded_user.password).not_to eq("password")
      expect(loaded_user.password_digest).not_to be_nil
      expect(loaded_user.password_digest).not_to eq("password")
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
end
