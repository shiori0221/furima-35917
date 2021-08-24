Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' } 
  root to: "items#index"
  resources :items do
    resources :purchases, only: [:index, :create]
    resources :comments, only: :create
    collection do
      get 'search'
    end
  end
  resources :users, only: [:show]
end
