require "rails_helper"

RSpec.describe UsersController, type: :routing do
  let(:default_format) { :json }

  describe "routing" do
    it "routes to GET '/api/admin/users' to get all users" do
      expect(get: "/api/admin/users").to route_to("users#index", format: default_format)
    end

    it "routes to GET '/api/admin/users/1' to get a user by ID" do
      expect(get: "/api/admin/users/1").to route_to("users#show", iD: "1", format: default_format)
    end

    it "routes to POST '/api/admin/users' to create a user" do
      expect(post: "/api/admin/users").to route_to("users#create", format: default_format)
    end

    it "routes to PUT '/api/admin/users/1' to update a user by ID" do
      expect(put: "/api/admin/users/1").to route_to("users#update", id: "1", format: default_format)
    end

    it "routes to PATCH '/api/admin/users/1' to update a user by ID" do
      expect(patch: "/api/admin/users/1").to route_to("users#update", id: "1", format: default_format)
    end

    it "routes to DELETE '/api/admin/users/1' to delete a user by ID" do
      expect(delete: "/api/admin/users/1").to route_to("users#destroy", id: "1", format: default_format)
    end
  end
end
