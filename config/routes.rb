Prodygia::Application.routes.draw do

  get '/admin', to: redirect('/admin/sign_in')
  get "admin/index"

  get "join_request/index"
  get "join_request/show"
  get "join_request/destroy"
  get "join_request/new"
  get "join_request/edit"
  get "join_request/create"
  get "join_request/update"
  resources :experts

  resources :contact_messages

  resources :propose_topics

  resources :sessions
  
  resources :admin do 

    collection do
      get 'sign_in'
    end

    collection do
      post 'authorize'
    end

    collection do 
      get 'sessions', to: 'admin#session_index'
      post 'sessions', to: 'admin#session_create'
      get 'sessions/new', to: 'admin#session_new', as:'session_new'

      get 'sessions/:id/edit', to: 'admin#session_edit', as: 'session_edit'
      get 'sessions/:id', to: 'admin#session_show', as: 'session'
      put 'sessions/:id', to: 'admin#session_update'
      patch 'sessions/:id', to: 'admin#session_update'
      delete 'sessions/:id', to: 'admin#session_destroy'
    end

    collection do 
      get 'experts', to: 'admin#expert_index'
      post 'experts', to: 'admin#expert_create'
      get 'experts/new', to: 'admin#expert_new', as: 'expert_new'

      get 'experts/:id/edit', to: 'admin#expert_edit', as: 'expert_edit'
      get 'experts/:id', to: 'admin#expert_show', as: 'expert'
      put 'experts/:id', to: 'admin#expert_update'
      patch 'experts/:id', to: 'admin#expert_update'
      delete 'experts/:id', to: 'admin#expert_destroy'
    end    

  end

  get "welcome/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: "welcome#index"

  get "welcome/about_us"
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
