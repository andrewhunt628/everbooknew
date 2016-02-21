Rails.application.routes.draw do
  resources :albums
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :pins
  resources :comments, only: [:create]

  resources :family_bonds, only: [:index, :new, :create, :destroy]
  resources :users, only: [:show]
  root "albums#index"

  get '*tags_list' => 'albums#index', as: :tag# this line should be last
end
