Rails.application.routes.draw do
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # User routes
  post '/signup', to: 'users#create'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'

  # MarketStocks routes
  resources :market_stocks, only: [:index] do
    collection do
      post 'update_prices'  # Endpoint to update market stock prices
    end
  end

  # Portfolio and nested stock routes
  resources :portfolios, only: [:show] do
    resources :stocks, only: [] do
      collection do
        post 'buy'  # Endpoint to buy stocks
      end
      member do
        delete 'sell'  # Endpoint to sell stocks
      end
    end
  end

  # Optionally define your root path route
  # root "some_controller#index"
  get '*path', to: "static_pages#frontend_index"
end
