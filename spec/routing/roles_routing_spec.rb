require "rails_helper"

RSpec.describe RolesController, type: :routing do
  let(:default_format) { :json }

  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/roles").to route_to("roles#index", format: default_format)
    end

    it "routes to #show" do
      expect(get: "/api/roles/1").to route_to("roles#show", id: "1", format: default_format)
    end

    it "routes to #create" do
      expect(post: "/api/roles").to route_to("roles#create", format: default_format)
    end

    it "routes to #update via PUT" do
      expect(put: "/api/roles/1").to route_to("roles#update", id: "1", format: default_format)
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/roles/1").to route_to("roles#update", id: "1", format: default_format)
    end

    it "routes to #destroy" do
      expect(delete: "/api/roles/1").to route_to("roles#destroy", id: "1", format: default_format)
    end
  end
end
