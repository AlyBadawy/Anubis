require "rails_helper"

RSpec.describe AccountsController, type: :routing do
  let(:default_format) { :json }

  describe "routing" do
    it "routes to #me" do
      expect(get: "/api/accounts/me").to route_to("accounts#me", format: default_format)
    end

    it "routes to #show" do
      expect(get: "/api/accounts/account/cool_user").to route_to("accounts#show", username: "cool_user", format: default_format)
    end

    it "routes to #register" do
      expect(post: "/api/accounts/register").to route_to("accounts#register", format: default_format)
    end

    it "routes to #update_profile" do
      expect(put: "/api/accounts/update").to route_to("accounts#update_profile", format: default_format)
    end

    it "routes to #delete_account" do
      expect(delete: "/api/accounts/delete_account").to route_to("accounts#delete_account", format: default_format)
    end
  end
end
