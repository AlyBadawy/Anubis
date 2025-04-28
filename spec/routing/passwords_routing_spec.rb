require "rails_helper"

RSpec.describe PasswordsController, type: :routing do
  let(:default_format) { :json }

  describe "routing" do
    it "routes to #forgot" do
      expect(post: "/api/password/forgot").to route_to("passwords#forgot_password", format: default_format)
    end

    it "routes to #reset" do
      expect(put: "/api/password/reset").to route_to("passwords#reset_password", format: default_format)
    end
  end
end
