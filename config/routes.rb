Prodygia::Application.routes.draw do

  resources :comments
  resources :consultations do
    member do
      get :accept
      get :reject
    end
  end

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

  ActiveAdmin.routes(self)
  mount Ckeditor::Engine => '/ckeditor'

  resources :articles do
    member do
      post :email_friend

      get :new_post_content
      get :edit_content
      patch :update_content
      get :post_a_draft
      post :update_timezone

      get :cancel_draft_content
    end
    post :create_post_content, on: :collection
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
      get :main_menu
      get :profile
      get :consultations
      get :sessions
      get :contents
      get :edit_profile
      patch :update_profile
      get :video_courses
      get :load_more
    end

    collection do
      get :refer_new_expert
      post :refer_new_expert
      get :pending_page
    end
  end

  controller :users do
    patch 'change_email'
    get 'validate_invite_email'
    get 'validate_user_name'

    get 'relationship/:the_followed' => :relationship, as: :relationship
    get 'subscirbe/:item_id' => :subscribe, as: :subscribe
    get 'following'
    get 'followers'
    get :validate_user_name
  end

  controller :mailchimp do
    post 'subscription'
    post 'guest_subscription'
  end

  scope "email" do
    controller :email_messages do
      get :new_share_message
      post :send_share_email
      get :new_refer_message
      get :validate_invite_email
    end
  end

  controller :dashboard do
    get :dashboard
    scope :dashboard, as: :dashboard do
      get :edit_profile
      get :post_new_article
      get :settings
      get :content
      get :produced_courses
      get :subscribed_courses
      get :favorite_experts
      get :favorite_content
      get :favorite_courses

      scope :content, as: :content do
        resources :articles, :video_interviews
      end
    end
  end

  get "/dashboard/refer_new_expert", to: "email_messages#new_refer_expert_message"
  get "/dashboard/refer_a_friend", to: "email_messages#new_refer_friend_message"

  resources :resources

  root to: "welcome#index"

  get "/about_us", to: 'static_pages#about_us'
  get "/for_experts", to: 'static_pages#for_experts'
  get "/faq", to: 'static_pages#faq'
  get "/terms", to: 'static_pages#terms'
  get "/privacy", to: 'static_pages#privacy'
  get "welcome/load_more", to: "welcome#load_more"
  get "/search", to: 'search#query', as: :search
  get "/search/autocomplete", to: 'search#autocomplete'

  # get "*page" => redirect("/")
end
