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
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
