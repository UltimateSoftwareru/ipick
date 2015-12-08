Rails.application.routes.draw do
  resources :orders, except: [:new, :edit]
  mount_devise_token_auth_for 'User', at: 'users'
end
