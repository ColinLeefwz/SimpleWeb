ActionController::Routing::Routes.draw do |map|
  map.resources :send_goods

  map.resources :feedbacks

  map.resources :mcities

  map.resources :mcategories

  map.resources :movie_releases

  map.resources :shop_index_structures

  map.resources :shop_template_structures

  map.resources :today_tuangous

  map.resources :today_discount_images

  map.resources :qdh_sms_outs

  map.resources :beeruser_gifts

  map.resources :beerreports

  map.resources :beerreport_qdhshops

  map.resources :good_outs

  map.resources :good_ins

  map.resources :friendly_links

  map.resources :goods

  map.resources :good_qdhshops

  map.resources :good_in_qdhshops

  map.resources :good_out_qdhshops

  map.resources :beerbuckets

  map.resources :beeruser_recharges

  map.resources :beeruser_recharge_qdhshops

  map.resources :beer_drivers

  map.resources :beer_driver_qdhshops

  map.resources :sms_qdhshops

  map.resources :staffs

  map.resources :staff_qdhshops

  map.resources :serveusers

  map.resources :serveuser_qdhshops

  map.resources :today_ishop_articles

  map.resources :today_articles

  map.resources :today_discount_titles

  map.resources :today_discounts

  map.resources :today_recommends

  map.resources :beerorders

  map.resources :beerorder_qdhshops

  map.resources :beerusers

  map.resources :beeruser_qdhshops

  map.resources :shop_actions

  map.resources :phone_lib_files

  map.resources :shop_send_phones

  map.resources :phone_libs

  map.resources :user_shop_likes

  map.resources :shop_space_discounts

  map.resources :lovewalls

  map.resources :block_menus

  map.resources :admin_photos
  map.resources :articles
  map.resources :template_flags

  map.resources :shop_templates

  map.resources :account_consumptions

  map.resources :account_buys

  map.resources :shop_applies
  map.resources :list_types

  map.resources :show_types

  map.resources :tuangou_navs

  map.resources :shop_certifications
  map.resources :certification

  map.resources :links

  map.resources :promotion_records

  map.resources :withdraw_cashes

  map.resources :referer_verifies

  map.resources :user_shop_scores

  map.resources :photo_slides

  map.resources :recharges, :collection => { :confirm => :get,:pay_notify => :post}

  map.resources :daily_tuangous

  map.resources :shop_transit

  map.resources :foreshow_tuangous

  map.resources :ending_tuangous

  map.resources :recommend_tuangous

=begin
  # resource route within a namespace:
  map.namespace :shop_space do |shop_space|
  # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
       shop_space.resources :space
  end
=end

  map.resources :spaces
  map.resources :space_templates
  map.resources :shop_photos
  map.resources :shop_articles
  map.resources :user_ishop_articles
  map.resources :user_ishop_shop_photos
  map.resources :shop_votes
  map.resources :plugins
  map.resources :menus
  map.resources :shop_menus
  map.resources :shop_space_index
  map.resources :shop_recycle
  map.resources :menu_stds
  map.resources :bugs

  map.resources :returns_infos

  map.resources :kbs

  map.resources :tgbaos

  map.resources :tgbao_reissue

  map.resources :tuangou_datas, :collection => { :out_excel => :get,:out_excel_tuangou => :get}

  map.resources :sms_fates, :collection => { :notice_all => :get}

  map.resources :fate_infos

  map.resources :fates

  map.resources :radio107s

  map.resources :score_journals

  map.resources :money_journals

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "index"

  map.resources :recommend_comments
  map.resources :discounts, :has_many => :comments
  map.resources :comments
  map.resources :recommend_discounts
  map.resources :categories
  map.resources :admins
  map.resources :shops, :has_many => :shop_logos
  map.resources :users, :has_many => :user_logos
  map.resources :sms_outs
  map.resources :sms_ins, :collection => { :radio107 => :get}
  map.resources :ddowns, :collection => { :sec_kill => :get}
  map.resources :consumptions
  map.resources :incomes
  map.resources :balances
  map.resources :subshops
  map.resources :seasons
  map.resources :areas
  map.resources :favorites
  map.resources :discountimages
  map.resources :activities, :has_many => :activity_items

  map.resources :dcashes
  map.resources :dcash_xfs
  map.resources :line_items

  map.resources :orders, :collection => { :show_trade => :get}

  map.resources :download_ranks

  map.resources :latest_discounts

  map.resources :keywords

  map.resources :pop_discounts

  map.resources :push_discounts
  map.resources :shop_runs

  map.resources :user_login_logs
  map.resources :shop_login_logs
  map.resources :admin_login_logs

  map.resources :shop_pays

  map.resources :vote_results

  map.resources :vote_items

  map.resources :votes

  map.resources :t_votes

  map.resources :sms_pushes

  map.resources :tuangous

  map.resources :shop_tuangous

  map.resources :rights
  map.resources :user_roles
  map.resources :roles
  map.resources :departs

  map.resources :radio996s
  map.resources :operation_logs
  map.resources :discount_pushes
  map.resources :tuangou_notices, :collection => {:get_yzm => :get, :confirm => :get}
  map.resources :account_ins, :collection => { :auto_complete_for_shop_id => :get }
  map.resources :account_outs

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end



  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller.:format'
  map.connect 'index_2', :controller => 'shop_space', :action => 'space'
end

