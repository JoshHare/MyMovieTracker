Rails.application.routes.draw do
  resources :reviews
  resources :watchlists

  root 'users#login'

  resources :users
  get 'login', to: 'users#login'
  post 'login', to: 'users#authenticate'
  get 'logout', to: 'users#logout'


  resources :movies do
    resources :reviews, only: [:index, :new, :create] # Include new and create actions for reviews
  end

  # Custom route for searching movies
  get '/search_movies', to: 'movies#search', as: 'search_movies'
  get '/search', to: 'movies#search', as: 'search'

  resources :seens, except: [:create, :destroy]
  post '/seens', to: 'seens#create', as: 'create_seen'
  delete '/seens/:id', to: 'seens#destroy', as: 'destroy_seen'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
