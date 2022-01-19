Rails.application.routes.draw do
  resources :investments
  resources :documents
  resources :interests
  devise_for :users
  resources :companies
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "investments#index"
end
