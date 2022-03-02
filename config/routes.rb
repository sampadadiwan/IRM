Rails.application.routes.draw do
  resources :payments
  resources :nudges
  resources :import_uploads
  resources :offers do
    patch 'approve', on: :member
  end

  resources :secondary_sales do
    patch 'make_visible', on: :member
  end

  resources :holdings
  resources :folders
  resources :investor_accesses do
    get 'search', on: :collection
    patch 'approve', on: :member
    post 'request_access', on: :collection
    post 'upload', on: :collection
  end
  resources :access_rights do
    get 'search', on: :collection
  end
  resources :deal_docs
  resources :notifications

  resources :deal_messages do
    post 'mark_as_task', on: :member
    patch 'task_done', on: :member
  end
  resources :deal_activities do
    get 'search', on: :collection
    get 'update_sequence', on: :member
    post 'toggle_completed', on: :member
  end
  resources :deal_investors do
    get 'search', on: :collection
  end
  resources :deals do
    get 'search', on: :collection
    post 'start_deal', on: :member
    get 'investor_deals', on: :collection
  end

  namespace :admin do
    resources :investors
    resources :users
    resources :notes
    resources :entities
    resources :documents
    resources :investments
    resources :access_rights
    resources :deals
    resources :deal_investors
    resources :deal_activities
    resources :deal_docs
    resources :deal_messages
    resources :holdings
    resources :offers
    resources :interests
    resources :folders
    resources :investor_accesses
    resources :secondary_sales
    root to: "investors#index"
  end

  resources :notes do
    get 'search', on: :collection
  end

  resources :investors do
    get 'search', on: :collection
  end

  resources :investments do
    get 'search', on: :collection
    get 'investor_investments', on: :collection
  end

  resources :documents do
    get 'search', on: :collection
    get 'investor_documents', on: :collection
  end

  resources :interests do
    patch 'short_list', on: :member
  end

  devise_for :users, controllers: {
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: 'users/confirmations'
  }

  resources :entities do
    get 'search', on: :collection
    get 'investor_entities', on: :collection
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

  require 'sidekiq/web'
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
end
