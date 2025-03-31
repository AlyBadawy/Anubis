require "rails_helper"

RSpec.describe RoleAssignmentsController, type: :routing do
  let(:default_format) { :json }

  describe "routing" do
    it "routes to #create" do
      expect(post: "/api/admin/role_assignments/assign").to route_to("role_assignments#create", format: default_format)
    end

    it "routes to #destroy" do
      expect(delete: "/api/admin/role_assignments/revoke").to route_to("role_assignments#destroy", format: default_format)
    end
  end
end
