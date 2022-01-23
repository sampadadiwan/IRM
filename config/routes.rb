Rails.application.routes.draw do
  resources :investor_accesses
  resources :doc_accesses
  resources :investors do
    get 'search', on: :collection
  end
  
  resources :investments do
    get 'search', on: :collection
  end

  resources :documents do
    get 'search', on: :collection
  end

  resources :interests
  
  devise_for :users, :controllers => {:registrations => "registrations"}

  resources :entities do
    get 'search', on: :collection
    get 'dashboard', on: :collection
  end

  resources :users do
    get 'search', on: :collection
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "entities#dashboard"
end
