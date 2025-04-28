require "rails_helper"

RSpec.describe RoleAssignment, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to(:role) }
    it { is_expected.to belong_to(:user) }
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:role_assignment)).to be_valid
    end
  end
end
