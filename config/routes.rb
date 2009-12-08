ActionController::Routing::Routes.draw do |map|
  
  # comments routes
  #map.edit_comment :controller => 'comments', :action => 'edit'
  
  #map.resources :comments

  # login/logout routes
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.resources :user_sessions
  
  map.resources :users

  # voting routes
  map.vote '/stories/:id/vote/:vote', :controller => 'stories', :action => 'vote'
  # sorting, with time
  map.sort '/stories/sort/:order/:sort/:time', :controller => 'stories', :action => 'index'
  map.connect '/stories/sort/:order/:sort/:time.:format', :controller => 'stories', :action => 'index'
  map.resources :stories do |story|
    story.resources :comments, :only => [:edit, :update, :create, :destroy]
  end
  map.spam 'spam/:id', :controller => 'comments', :action => 'spam'
  map.ham 'ham/:id', :controller => 'comments', :action => 'ham'
  map.remove_all_spam 'remove_all_spam/:id', :controller => 'stories', :action => 'remove_all_spam'

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
