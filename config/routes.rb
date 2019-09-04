Rails.application.routes.draw do
  root to: 'polls#index'
  devise_for :users
  #### add specific routes
  resources :polls
  resources :events
  resources :responses
end
