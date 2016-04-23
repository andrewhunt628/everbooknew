# load class ApiConstraint
require 'api_constraint'

Rails.application.routes.draw do

  get 'friendship/create'

  get 'friendship/destroy'

  resources :albums
  post '/uploader', to: 'uploader#upload', as: :upload
  get '/uploader/finish', to: 'uploader#finish'
  post '/uploader/save', to: 'uploader#save', as: :save
  get '/uploader', to: 'uploader#index', as: :upload_index

  get '/explore', to: 'explore#index'
  post '/friend_with/:friend_id', to: 'explore#add_friendship', as: :friend_with

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :pins
  delete '/pins/:id/tags/:tag', to: 'pins#remove_tag'
  resources :comments, only: [:create]

  resources :family_bonds, only: [:index, :new, :create, :destroy]

  # for the Amistad model
  resources :friends, :controller => 'friendships', :except => [:show, :edit] do
    get "requests", :on => :collection
    get "invites", :on => :collection
  end

  match '/users/:id/finish_signup', to: 'users#finish_signup', via: [:get, :patch], as: :finish_signup
  resources :users, only: [:show, :update, :destroy] do
    member do
      get '/security/change_password/', to: 'users#form_change_password'
      patch :change_password
    end
  end

  # routes for Api
  # default response format for Api is JSON
  namespace :api, {defaults: {format: "json"}} do
    # make Api Version 1 as default Api
    # class ApiConstraint is inside lib/api_constraint.rb
    scope module: :v1, constraints: ApiConstraint.new(version: 1, default: true) do
      get '/users', to: 'users#show'
      get '/users/list', to: 'users#index'
      patch '/users/security/change_password', to: 'users#change_password'
      
      # handling log in, log out and sign up
      post 'users/sign_in', to: 'sessions#create'
      delete 'users/sign_out', to: 'sessions#destroy'
      
      # we must tell Devise to custom their routes
      devise_scope :user do
        # for sign up
        post '/users/sign_up', to: 'registrations#create'
        # for invitation 
        post '/users/invitation', to: 'invitations#create'

        # for passwords
        post '/users/password', to: 'passwords#create'
        put '/users/password', to: 'passwords#update'
      end

      resources :pins, except: [:edit, :new]
      resources :albums, except: [:edit, :new]
      resources :comments,only: :create
      resources :family_bonds, only: [:index,:create, :destroy]

      post '/user/oauth_verification/google', to: 'user/oauth_verifications#verify_google_token'

      if Rails.env.development?
        match '*path', via: [:options], to: lambda {|_| [200, {'Content-type' => 'text/plain'}, []]}
      end

    end
  end
  
  root 'index#index'

  get '*tags_list' => 'albums#index', as: :tag# this line should be last
end
