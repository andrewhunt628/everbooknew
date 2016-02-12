Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }



  resources :pins

  resources :family_bonds, only: [:index, :new, :create, :destroy]
  resources :users, only: [:show]
  root "pins#index"

  get '*tags_list' => 'pins#index', as: :tag
end
