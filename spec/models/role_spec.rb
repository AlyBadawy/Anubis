require "rails_helper"

RSpec.describe Role, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:role_name) }
    it { is_expected.to validate_uniqueness_of(:role_name) }
  end

  describe "normalization" do
    it "normalizes role_name to titlecase" do
      role = create(:role, role_name: "super admin")
      expect(role.role_name).to eq("Super Admin")
    end

    it "strips whitespace from role_name" do
      role = create(:role, role_name: "  admin  ")
      expect(role.role_name).to eq("Admin")
    end
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:role)).to be_valid
    end

    it "creates an admin role" do
      role = create(:role, :admin)
      expect(role.role_name).to eq("Admin")
    end

    it "creates a user role" do
      role = create(:role, :user)
      expect(role.role_name).to eq("User")
    end
  end

  describe "Associations" do
    pending "All associations are tested in the respective model spec files"
  end
end
