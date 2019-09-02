Rails.application.routes.draw do
  root to: 'polls#index'
  devise_for :users
  resources :polls
end
