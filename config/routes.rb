Prodygia::Application.routes.draw do

  devise_for :users
  get '/admin', to: redirect('/admin/sign_in')
  get "admin/index"

  get "join_request/index"
  get "join_request/show"
  get "join_request/destroy"
  get "join_request/new"
  get "join_request/edit"
  get "join_request/create"
  get "join_request/update"
  resources :experts

  resources :contact_messages

  resources :propose_topics

  resources :admin do

    collection do
      get 'sign_in'
    end

    collection do
      post 'authorize'
    end

    collection do
      get 'sessions', to: 'admin#session_index'
      post 'sessions', to: 'admin#session_create'
      get 'sessions/new', to: 'admin#session_new', as:'session_new'

      get 'sessions/:id/edit', to: 'admin#session_edit', as: 'session_edit'
      get 'sessions/:id', to: 'admin#session_show', as: 'session'
      put 'sessions/:id', to: 'admin#session_update'
      patch 'sessions/:id', to: 'admin#session_update'
      delete 'sessions/:id', to: 'admin#session_destroy'
    end

    collection do
      get 'experts', to: 'admin#expert_index'
      post 'experts', to: 'admin#expert_create'
      get 'experts/new', to: 'admin#expert_new', as: 'expert_new'

      get 'experts/:id/edit', to: 'admin#expert_edit', as: 'expert_edit'
      get 'experts/:id', to: 'admin#expert_show', as: 'expert'
      put 'experts/:id', to: 'admin#expert_update'
      patch 'experts/:id', to: 'admin#expert_update'
      delete 'experts/:id', to: 'admin#expert_destroy'
    end

  end

  get "welcome/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: "welcome#index"
  get "/contact", to: "welcome#contact"
  get "/faq", to: "welcome#faq"
  get "/for_experts", to: "welcome#for_experts"
  get "/for_members", to: "welcome#for_members"
  get "/privacy", to: "welcome#privacy"
  get "/terms", to: "welcome#terms"
  get "video_page/:id", to: "welcome#video_page", as: 'video_page'
  get "text_page/:id", to: "welcome#text_page", as: 'text_page'
 end
