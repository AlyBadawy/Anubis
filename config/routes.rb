Rails.application.routes.draw do
  scope "/api", defaults: { format: :json } do
    scope "/admin" do
      resources :users
      resources :roles
      namespace :role_assignments do
        post "assign", action: :create
        delete "revoke", action: :destroy
      end
    end

    scope "accounts" do
      # get "current", to: "accounts#current"
      # get "profile", to: "accounts#show", param: :username
      # post "login", to: "accounts#login"
      # post "logout", to: "accounts#logout"
      # post "register", to: "accounts#register"
      # post "forgot_password", to: "accounts#forgot_password"
      # post "reset_password", to: "accounts#reset_password"
      # post "update_password", to: "accounts#update_password"
      # post "update_profile", to: "accounts#update_profile"
      # post "update_avatar", to: "accounts#update_avatar"
      # post "update_notification_settings", to: "accounts#update_notification_settings"
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
