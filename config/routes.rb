Prodygia::Application.routes.draw do

  resources :courses do
    member do
      get :preview
      get :purchase
      get :enroll
      get :enroll_confirm
      post :sign_up_confirm
    end
  end

  resources :sections
  resources :video_interviews
  resources :announcements

  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: "users/omniauth_callbacks", invitations: 'invitations', passwords: "users/passwords" }

  get "/users/validate_invite_email", to: 'users#validate_invite_email'

  resources :users

  ActiveAdmin.routes(self)
  mount Ckeditor::Engine => '/ckeditor'

  resources :sessions do
    member do
      get :enroll
      get :enroll_confirm
      get :purchase
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

      get :cancel_draft_content
    end
    post :create_post_content, on: :collection
    post :create_live_session, on: :collection
  end


  resources :orders do
    member do
      get :execute
      get :cancel
    end
  end

  resources :members do
    member do
      get :activity_stream
      get :dashboard
      get :profile
      get :edit_profile
      patch :update_profile
      get :refer_a_friend
      get :experts
      get :contents
      get :video_on_demand
      get :vod_library
    end
  end

  resources :experts do
    member do
      get :activity_stream
      get :dashboard
      get :main_menu
      get :pending_page
      get :profile
      get :sessions
      get :contents
      get :edit_profile
      patch :update_profile
      get :video_courses
    end

    collection do
      get :refer_new_expert
      post :refer_new_expert
    end
  end

  controller :users do
    get 'relationship/:the_followed' => :relationship, as: :relationship
    get 'subscirbe_session/:session_id' => :subscribe_session, as: :subscribe_session
    get 'subscirbe_course/:course_id' => :subscribe_course, as: :subscribe_course
    get 'subscirbe_video_interview/:video_interview_id' => :subscribe_video_interview, as: :subscribe_video_interview
    get 'following'
    get 'followers'
  end

  resources :resources 

  root to: "welcome#index"

  get "/about_us", to: 'static_pages#about_us'
  get "/for_experts", to: 'static_pages#for_experts'
  get "/faq", to: 'static_pages#faq'
  get "/terms", to: 'static_pages#terms'
  get "/privacy", to: 'static_pages#privacy'

  get "/article/:id", to: "sessions#show", as: :article

  get "*page" => redirect("/")
end
