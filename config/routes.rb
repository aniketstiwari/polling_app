Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
	  authenticated :user do
	    root 'polls#index', as: :authenticated_root
	  end
	  unauthenticated do
	    root 'devise/sessions#new', as: :unauthenticated_root
	  end
  end
  resources :polls
end
