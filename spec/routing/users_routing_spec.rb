require "rails_helper"

RSpec.describe UsersController, type: :routing do
  let(:default_format) { :json }

  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/admin/users").to route_to("users#index", format: default_format)
    end

    it "routes to #show" do
      expect(get: "/api/admin/users/1").to route_to("users#show", id: "1", format: default_format)
    end

    it "routes to #create" do
      expect(post: "/api/admin/users").to route_to("users#create", format: default_format)
    end

    it "routes to #update via PUT" do
      expect(put: "/api/admin/users/1").to route_to("users#update", id: "1", format: default_format)
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/admin/users/1").to route_to("users#update", id: "1", format: default_format)
    end

    it "routes to #destroy" do
      expect(delete: "/api/admin/users/1").to route_to("users#destroy", id: "1", format: default_format)
    end
  end
end
