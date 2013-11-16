Prodygia::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: "users/omniauth_callbacks", invitations: 'invitations', passwords: "users/passwords" }

  resources :users

  ActiveAdmin.routes(self)
  mount Ckeditor::Engine => '/ckeditor'

  resources :sessions do
    member do
      get :enroll
      get :buy_now
      post :sign_up_buy
      get :free_confirm
      post :sign_up_confirm
    end
  end

  resources :orders do
    get :execute
    get :cancel
  end

  resources :experts, shallow: true do
    member do
      get :dashboard
      get :main_menu
      get :pending_page
      get :profile
      get :sessions
      get :contents
      get :edit_profile
      patch :update_profile
    end
    
    resources :sessions do
      member do
        get :new_post_content
        get :edit_content
        get :cancel_content
        patch :update_content
        get :new_live_session
        get :edit_live_session
        patch :update_live_session
        get :post_a_draft
        post :update_timezone
      end
      post :create_post_content, on: :collection
      post :create_live_session, on: :collection
    end

    collection do
      get :refer_new_expert
      post :refer_new_expert
			get :validate_invite_email
    end
  end

  root to: "welcome#index"

  get "/:page", to: 'static_pages#static'

  get "video_page/:id", to: "welcome#video_page", as: 'video_page'
  get "text_page/:id", to: "welcome#text_page", as: 'text_page'
  get "session/:id", to: "welcome#session_page", as: 'session_page'

  get "/paypal_callback", to: 'session#paypal_callback'
end
