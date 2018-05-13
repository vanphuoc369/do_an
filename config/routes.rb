Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  root "static_pages#home"

  get "/signup", to: "users#new"
  get "/login", to: "logins#new"
  get "/static_pages", to: "static_pages#index"
  get "/home_notifications", to: "notifications#home"
  post "/login", to: "logins#create"
  delete "/logout", to: "logins#destroy"
  resources :users, except: [:destroy, :index]
  resources :account_activations, only: [:edit]
  resources :notifications, only: [:index]
  resources :passwords, only: [:new, :create, :edit, :update]
  resources :books, only: [:index, :show] do
    resources :user_books, only: %i(create update)
    resources :reviews, except: [:index] do
      resources :comments, except: [:index]
    end
  end

  namespace :admin do
    root "static_pages#index"

    resources :books, except: :show
    resources :users, except: :show
    resources :reviews, only: [:show, :index, :destroy]
  end
end
