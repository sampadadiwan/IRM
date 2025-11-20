resources :support_agents do
  post 'run', on: :collection
end

resources :agent_charts do
  post 'regenerate', on: :member
end

resources :ai_checks do
  post 'run_checks', on: :collection
  get 'run_checks', on: :collection
end

resources :chats do
  post :send_message, on: :member
end

resources :ai_rules

# AI Portfolio Report Builder
resources :ai_portfolio_reports do
  resources :ai_report_sections do
    member do
      post :add_content
    end
  end

  resources :ai_chat_messages, only: [:create]
end
