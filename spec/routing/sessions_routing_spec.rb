require "rails_helper"

RSpec.describe SessionsController, type: :routing do
  let(:default_format) { :json }

  describe "routing" do
    it "routes to GET '/api/sessions' to get all sessions of current user" do
      expect(get: "/api/sessions").to route_to("sessions#index", format: default_format)
    end

    it "routes to GET '/api/sessions/current' to get current session" do
      expect(get: "/api/sessions/current").to route_to("sessions#show", format: default_format)
    end

    it "routes to GET '/api/sessions/id/123' to get session by Id" do
      expect(get: "/api/sessions/id/123").to route_to("sessions#show", format: default_format, id: "123")
    end

    it "routes to POST '/api/sessions/login' to login" do
      expect(post: "/api/sessions/login").to route_to("sessions#login", format: default_format)
    end

    it "routes to DELETE '/api/sessions/logout' to logout the user" do
      expect(delete: "/api/sessions/logout").to route_to("sessions#logout", format: default_format)
    end

    it "routes to PUT '/api/sessions/refresh' to refresh the session" do
      expect(put: "/api/sessions/refresh").to route_to("sessions#refresh", format: default_format)
    end

    it "routes to DELETE '/api/sessions/revoke' to revoke the session" do
      expect(delete: "/api/sessions/revoke").to route_to("sessions#revoke", format: default_format)
    end

    it "routes to DELETE '/api/sessions/id/1/revoke' to revoke a session by Id" do
      expect(delete: "/api/sessions/id/1/revoke").to route_to("sessions#revoke", format: default_format, id: "1")
    end

    it "routes to DELETE '/api/sessions/revoke_all' to revoke all sessions of current user" do
      expect(delete: "/api/sessions/revoke_all").to route_to("sessions#revoke_all", format: default_format)
    end
  end
end
