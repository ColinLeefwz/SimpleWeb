Prodygia::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: "users/omniauth_callbacks", invitations: 'invitations' }

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

  resources :experts do
    member do
      get :dashboard
      get :new_post_content
      post :create_post_content

      get :new_session
      post :create_session
    end
  end

  root to: "welcome#index"

  get "/:page", to: 'static_pages#static'

  get "video_page/:id", to: "welcome#video_page", as: 'video_page'
  get "text_page/:id", to: "welcome#text_page", as: 'text_page'
  get "session/:id", to: "welcome#session_page", as: 'session_page'

  get "/paypal_callback", to: 'session#paypal_callback'
end
