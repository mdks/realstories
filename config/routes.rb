ActionController::Routing::Routes.draw do |map|
  # reset code and activate code routes
  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.send_reset_code '/send_reset_code', :controller => 'users', :action => 'send_reset_code'
  map.reset_password '/reset_password/:reset_code', :controller => 'users', :action => 'reset_password'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.resources :users

  # feed routes
  #map.connect '/stories/feed', :controller => 'stories', :action => 'index', :format => 'atom'
  # voting routes
  map.vote '/stories/:id/vote/:vote', :controller => 'stories', :action => 'vote'
  # sorting, with time
  map.sort '/stories/sort/:order/:sort/:time', :controller => 'stories', :action => 'index'
  map.connect '/stories/sort/:order/:sort/:time.:format', :controller => 'stories', :action => 'index'
  map.resources :stories


  map.login '/login', :controller => 'access', :action => 'login'
  map.logout '/logout', :controller => 'access', :action => 'logout'
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

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "stories"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id', :controller => 'stories'
  #map.connect ':controller/:action/:id.:format', :controller => 'stories'

end
