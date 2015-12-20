Rails.application.routes.draw do
  resources :orders, only: [:index, :show, :create, :update, :destroy]
  resources :deals, only: [:index, :show, :update, :create]

  resources :operators, :users, :couriers, only: [] do
    collection do
      get :me
      get :index
    end
    member do
      get :show
      put :update
    end
  end

  mount_devise_token_auth_for 'User', at: 'auth/users'
  mount_devise_token_auth_for 'Courier', at: 'auth/couriers'
  mount_devise_token_auth_for 'Operator', at: 'auth/operators'
end
