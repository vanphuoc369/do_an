Rails.application.routes.draw do

  root "static_pages#home"

  get "/signup", to: "users#new"
  get "/login", to: "logins#new"
  post "/login", to: "logins#create"
  delete "/logout", to: "logins#destroy"
  resources :users, except: :destroy
  resources :account_activations, only: [:edit]

  namespace :admin do
    root "static_pages#index"
  end
end