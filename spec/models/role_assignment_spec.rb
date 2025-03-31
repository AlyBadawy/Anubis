require "rails_helper"

RSpec.describe RoleAssignment, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to(:role) }
    it { is_expected.to belong_to(:user) }
  end
end
