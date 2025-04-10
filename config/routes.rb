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
      # get "me", to: "accounts#me", as: :me
      get "profile/:username", to: "accounts#show", as: :profile_by_username
      post "register", to: "accounts#register", as: :register
      # post "update_profile", to: "accounts#update_profile"
      # post "update_avatar", to: "accounts#update_avatar"
      # post "update_notification_settings", to: "accounts#update_notification_settings"
    end

    scope "sessions" do
      get "", to: "sessions#index", as: :index_sessions
      get "current", to: "sessions#show", as: :current_session
      get "id/:id", to: "sessions#show", as: :session
      post "login", to: "sessions#login", as: :login
      # delete "logout", to: "sessions#logout", as: :logout
      # put "refresh", to: "sessions#refresh", as: :refresh_session
      # delete "revoke", to: "sessions#revoke", as: :revoke_session
      # delete "revoke_all", to: "sessions#revoke_all", as: :revoke_all_sessions
    end

    scope "password" do
      # post "forgot_password", to: "accounts#forgot_password"
      # post "reset_password", to: "accounts#reset_password"
      # post "update_password", to: "accounts#update_password"
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
