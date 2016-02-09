Rails.application.routes.draw do
  devise_for :users
  
  resources :pins
  resources :family_bonds, only: [:index, :new, :create, :destroy]
  root "pins#index"

end
