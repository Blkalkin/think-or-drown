Rails.application.routes.draw do
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # User routes
  post '/signup', to: 'users#create'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      post 'update_current_value'
      post 'update_current_cash'
      post 'manage_portfolio_transaction'
      get 'portfolio_data'
      post 'update_current_cash'
      get 'get_user_info'
    end
  end

  # Optionally define your root path route
  # root "some_controller#index"
  get '*path', to: "static_pages#frontend_index"
end
