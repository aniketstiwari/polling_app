Rails.application.routes.draw do
  root to: 'polls#index'
  devise_for :users
  resources :polls, only: [:index, :new, :create]
  resources :events, only: [:new, :create, :index]
  resources :responses, only: [:new, :create]
  resources :restaurants, only: [:new, :create, :index]
end
