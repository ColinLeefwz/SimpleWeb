Prodygia::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # devise_for :users

  resources :experts

  get "welcome/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: "welcome#index"
  get "/about_us", to: "welcome#about_us"
  get "/faq", to: "welcome#faq"
  get "/for_experts", to: "welcome#for_experts"
  get "/for_members", to: "welcome#for_members"
  get "/privacy", to: "welcome#privacy"
  get "/terms", to: "welcome#terms"
  get "video_page/:id", to: "welcome#video_page", as: 'video_page'
  get "text_page/:id", to: "welcome#text_page", as: 'text_page'
 end
