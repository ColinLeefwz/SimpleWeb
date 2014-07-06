<<<<<<< HEAD
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
    get 'following/:target_id' => :following, as: :following
    get 'favorite/:item_type/:item_id' => :favorite, as: :favorite

    patch 'change_email'
    get 'validate_user_name'

    get 'relationship/:the_followed' => :relationship, as: :relationship
    get 'subscirbe/:item_id' => :subscribe, as: :subscribe
    get 'followers'
  end

  controller :mailchimp do
    post 'subscription'
    post 'guest_subscription'
  end

  resources :activity_stream

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
      get :activity_stream
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
=======
Lianlian::Application.routes.draw do
  mount Resque::Server, :at => "/resque"
  
  resources :shop_notices

  resources :shop_coupons do
    collection do
      get 'users'
      get 'ajax_deply'
      get 'ajax_del'
      get 'show_img2'
      get 'cancel_crop'
      get 'all_img'
      get 'newly_down'
      get 'newly_use'
      post 'crop'
      get 'new2'
      post 'create2'
      get "resend"

    end
  end

  resources :checkins do
    collection do
      post 'new_shop'
    end
  end

  #post "shops/manual"
  
  resources :users do
    resources :user_logos
  end
  resources :admins do
    member { get "dest"}
  end

  resources :admin_parties do
    collection do
      get 'ajax_over'
      get 'ajax_delay'
    end
  end
  resources :mshops
  resources :mcities
  resources :mcategories

  #resources :admin_shops
  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  #match ':controller(/:action(/:id(.:format)))'


  match "esprit" => redirect("/w/esprit")

  match ':controller/:action' => ":controller#:action"
  match ':controller/:action(.:format)'  => ":controller#:action"
  match ':controller' => ":controller#index"

  match 'shop3_faqs/article_image_upload/:id' => 'shop3_faqs#article_image_upload'

  root :to => 'Index#index'
>>>>>>> b8c272e31d97492bb030400d7034cb2d7a03ce34
end
