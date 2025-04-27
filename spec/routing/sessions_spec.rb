require "rails_helper"

RSpec.describe SessionsController, type: :routing do
  let(:default_format) { :json }

  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/sessions").to route_to("sessions#index", format: default_format)
    end

    it "routes to #show" do
      expect(get: "/api/sessions/current").to route_to("sessions#show", format: default_format)

      expect(get: "/api/sessions/id/123").to route_to("sessions#show", format: default_format, id: "123")
    end

    it "routes to #login" do
      expect(post: "/api/sessions/login").to route_to("sessions#login", format: default_format)
    end

    it "routes to #logout" do
      expect(delete: "/api/sessions/logout").to route_to("sessions#logout", format: default_format)
    end

    it "routes to #refresh" do # rubocop:disable RSpec/PendingWithoutReason
      expect(put: "/api/sessions/refresh").to route_to("sessions#refresh", format: default_format)
    end

    it "routes to #revoke" do # rubocop:disable RSpec/PendingWithoutReason
      expect(delete: "/api/sessions/revoke").to route_to("sessions#revoke", format: default_format)
    end

    it "routes to #revoke_all" do # rubocop:disable RSpec/PendingWithoutReason
      expect(delete: "/api/sessions/revoke_all").to route_to("sessions#revoke_all", format: default_format)
    end
  end
end
