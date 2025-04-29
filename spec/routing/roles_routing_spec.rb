require "rails_helper"

RSpec.describe RolesController, type: :routing do
  let(:default_format) { :json }

  describe "routing" do
    it "routes to GET '/api/admin/roles' to get all roles" do
      expect(get: "/api/admin/roles").to route_to("roles#index", format: default_format)
    end

    it "routes to GET '/api/admin/roles/1' to get a role by ID" do
      expect(get: "/api/admin/roles/1").to route_to("roles#show", id: "1", format: default_format)
    end

    it "routes to POST '/api/admin/roles' to create a role" do
      expect(post: "/api/admin/roles").to route_to("roles#create", format: default_format)
    end

    it "routes to PUT '/api/admin/roles/1' to update a role by ID" do
      expect(put: "/api/admin/roles/1").to route_to("roles#update", id: "1", format: default_format)
    end

    it "routes to PATCH '/api/admin/roles/1' to update a role by ID" do
      expect(patch: "/api/admin/roles/1").to route_to("roles#update", id: "1", format: default_format)
    end

    it "routes to DELETE '/api/admin/roles/1' to delete a role by ID" do
      expect(delete: "/api/admin/roles/1").to route_to("roles#destroy", id: "1", format: default_format)
    end
  end
end
