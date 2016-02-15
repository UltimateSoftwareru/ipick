Rails.application.routes.draw do
  apipie
  resources :orders, only: [:index, :show, :create, :update]
  resources :complains, only: [:index, :show, :create, :update]
  resources :deals, only: [:index, :show, :create, :update]
  resources :addresses, only: [:index, :show, :update, :create, :destroy]
  resources :transports, only: [:index, :show]
  resources :activities, only: [:index, :show]

  resources :operators, :people, :couriers, only: [] do
    collection do
      get :me
      get :index
    end
    member do
      get :show
      patch :update
    end
  end

  mount_devise_token_auth_for 'User', at: 'auth'
  mount_devise_token_auth_for 'Person', at: '/people/auth'
  mount_devise_token_auth_for 'Courier', at: '/couriers/auth'
  mount_devise_token_auth_for 'Operator', at: '/operators/auth'

  get '/(*path)' => "home#index", as: :root, format: :html
end
