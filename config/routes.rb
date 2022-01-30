Rails.application.routes.draw do
  resources :deal_docs
  resources :deal_messages
  resources :deal_activities do
    get 'search', on: :collection
    post 'update_sequence', on: :member
  end
  resources :deal_investors do
    get 'search', on: :collection
  end
  resources :deals do
    get 'search', on: :collection
  end
  
  namespace :admin do
      resources :investors
      resources :users
      resources :notes
      resources :entities
      resources :investor_accesses
      resources :documents
      resources :doc_accesses
      resources :investments

      root to: "investors#index"
    end
  
  resources :notes do
    get 'search', on: :collection
  end
  
  resources :investor_accesses do
    get 'search', on: :collection
  end

  resources :doc_accesses do 
    post 'send_email', on: :member
    get 'search', on: :collection
  end

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
    get 'investor_view', on: :member
  end

  resources :users do
    get 'search', on: :collection
    get 'welcome', on: :collection
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "entities#dashboard"
end
