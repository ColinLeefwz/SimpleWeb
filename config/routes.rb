Prodygia::Application.routes.draw do

  devise_for :users

	resources :users

  mount Ckeditor::Engine => '/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

	resources :sessions do
		member do
			get :enroll
		end
	end

  root to: "welcome#index"

  get "/:page", to: 'static_pages#static'

  get "video_page/:id", to: "welcome#video_page", as: 'video_page'
  get "text_page/:id", to: "welcome#text_page", as: 'text_page'
 end
