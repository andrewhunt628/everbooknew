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
    namespace :v1 do
      resources :users do

      end
    end
  end

  get "uploading" => "pins#uploading", as: :uploading

  root "albums#index"

  get '*tags_list' => 'albums#index', as: :tag# this line should be last
end
