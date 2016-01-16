Rails.application.routes.draw do
  resources :orders, only: [:index, :show, :create, :update, :destroy]
  resources :complains, only: [:index, :show, :create, :update, :destroy]
  resources :deals, only: [:index, :show, :update, :create]
  resources :addresses, only: [:index, :show, :update, :create, :destroy]
  resources :transports, only: [:index, :show]

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
  mount_devise_token_auth_for 'Person', at: '/persons/auth'
  mount_devise_token_auth_for 'Courier', at: '/couriers/auth'
  mount_devise_token_auth_for 'Operator', at: '/operators/auth'
end
