Rails.application.routes.draw do

  # routes to handle errors in json format
  # get "/404" => "errors#not_found"
  # get "/500" => "errors#exception"
  # get "/401" => "errors#unauthorized"
  
  resources :albums

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :pins
  resources :comments, only: [:create]

  resources :family_bonds, only: [:index, :new, :create, :destroy]
  resources :users, only: [:show]

  # routes for Api
  # default response format for Api is JSON
  namespace :api, {defaults: {format: "json"}} do
    namespace :v1 do
      # devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
      resources :users, only: :index
      # handling log in, log out and sign up
      post "users/sign_in", to: "sessions#create"
      delete "users/sign_out", to: "sessions#destroy"
      
      # we must tell Devise to custom their routes
      devise_scope :user do
        # for sign up
        post "/users/sign_up", to: "registrations#create"
        # for invitation 
        post "/users/invitation", to: "invitations#create"

        # for passwords
        post "/users/password", to: "passwords#create"
        put "/users/password", to: "passwords#update"
      end

      resources :pins, except: [:edit, :new]
      resources :albums, except: [:edit, :new]
    end
  end
  

  get "uploading" => "pins#uploading", as: :uploading

  root "albums#index"

  get '*tags_list' => 'albums#index', as: :tag# this line should be last
end
