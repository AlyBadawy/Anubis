require "rails_helper"

RSpec.describe AccountsController, type: :routing do
  let(:default_format) { :json }

  describe "routing" do
    it "routes to #show" do
      expect(get: "/api/accounts/profile/cool_user").to route_to("accounts#show", username: "cool_user", format: default_format)
    end

    it "routes to #register" do
      expect(post: "/api/accounts/register").to route_to("accounts#register", format: default_format)
    end
  end
end
