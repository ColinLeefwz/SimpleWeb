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
  resources :mobile_spaces, :only => [:new, :create]

    scope '/~:space_id', :module => 'dashboard', :as => 'dashboard' do
      root :to => 'mobile_articles#index'
      
      
      resources :mobile, :only => [:index]
      resource :billing, :only => [:show]

      # resources :orders, :only => [:index, :new, :create, :show, :destroy] do
      #   collection do
      #     post :alipay_notify
      #   end
      # end
      resources :mobile_orders, :only => [:index]
      resources :mobile_banners, :only => [:index, :show, :edit, :create, :update, :destroy]

      resource :mobile_settings, :only => [:show, :update]
      resources :members, :only => [:index, :destroy]
      resources :mobile_articles, :only => [:new, :create, :edit, :update, :show, :destroy]
    end


  match "esprit" => redirect("/w/esprit")

  match ':controller/:action' => ":controller#:action"
  match ':controller/:action(.:format)'  => ":controller#:action"
  match ':controller' => ":controller#index"

  match 'shop3_faqs/article_image_upload/:id' => 'shop3_faqs#article_image_upload'
  match 'mobile_articles/article_image_upload/:id' => 'mobile_articles#article_image_upload'

  root :to => 'Index#index'
end
