# load class ApiConstraint
require "api_constraint"

Rails.application.routes.draw do

  resources :albums

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :pins
  resources :comments, only: [:create]

  resources :family_bonds, only: [:index, :new, :create, :destroy]
  resources :users, only: [:show]

  # routes for Api
  # default response format for Api is JSON
  namespace :api, {defaults: {format: "json"}} do
    # make Api Version 1 as default Api
    # class ApiConstraint is inside lib/api_constraint.rb
    scope module: :v1, constraints: ApiConstraint.new(version: 1, default: true) do
      resources :users, only: [:index, :show]
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
      resources :comments,only: :create
      resources :family_bonds, only: [:index,:create, :destroy]

      post "/user/oauth_verification/google", to: "user/oauth_verifications#verify_google_token"
    end
  end
  

  get "uploading" => "pins#uploading", as: :uploading

  root "albums#index"

  get '*tags_list' => 'albums#index', as: :tag# this line should be last
end
