Lianlian::Application.routes.draw do
  resources :shop_notices
  resources :checkins

  #post "shops/manual"
  
  resources :users do
    resources :user_logos
  end
  resources :rights
  resources :admins
  resources :departs
  resources :roles
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
  match ':controller/:action' => ":controller#:action"
  match ':controller/:action(.:format)'  => ":controller#:action"
  match ':controller' => ":controller#index"

  
end
