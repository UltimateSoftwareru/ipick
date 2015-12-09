Rails.application.routes.draw do
  resources :orders, except: [:new, :edit]
  mount_devise_token_auth_for 'User', at: 'users'

  mount_devise_token_auth_for 'Courier', at: 'auth'

  mount_devise_token_auth_for 'Operator', at: 'operators_auth'
  as :operator do
    # Define routes for Operator within this block.
  end
  as :courier do
    # Define routes for Courier within this block.
  end
end
