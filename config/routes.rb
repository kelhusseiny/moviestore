Rails.application.routes.draw do

  # Root page
  root 'movies#index'

  # Devise user authentication
  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }

  # Movies
  resources :movies, only: [:show, :index]

  # Shopping Cart
  resource :cart, only: [:show] do
    put 'add/:movie_id', to: 'carts#add', as: :add_to
    put 'remove/:movie_id', to: 'carts#remove', as: :remove_from
  end

  ## Braintree payments
  # Payment Info
  resources :transactions, only: [:new, :create]
end
