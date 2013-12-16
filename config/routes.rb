Prodygia::Application.routes.draw do

  resources :courses
  get 'courses/:id/preview' => 'courses#preview', as: :course_preview

  resources :sections
  resources :video_interviews

  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: "users/omniauth_callbacks", invitations: 'invitations', passwords: "users/passwords" }

	get "/users/validate_invite_email", to: 'users#validate_invite_email'

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
      post :email_friend

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

  resources :orders do
    get :execute
    get :cancel
  end

  resources :members do
    member do
      get :dashboard
      get :profile
      get :edit_profile
      patch :update_profile
      get :refer_a_friend
      get :experts
      get :contents
      get :video_on_demand
    end
  end

  resources :experts do
    member do
      get :dashboard
      get :main_menu
      get :pending_page
      get :profile
      get :sessions
      get :contents
      get :edit_profile
      patch :update_profile
      get :video_on_demand
    end

    collection do
      get :refer_new_expert
      post :refer_new_expert
    end
  end

  controller :users do
    get 'relationship/:the_followed' => :relationship, as: :relationship
    get 'subscirbe_session/:session_id' => :subscribe_session, as: :subscribe_session
    get 'following'
    get 'followers'
  end

  resources :resources 

  root to: "welcome#index"

  get "/about_us", to: 'static_pages#about_us'
  get "/for_experts", to: 'static_pages#for_experts'
  get "/:page", to: 'static_pages#static'

end
