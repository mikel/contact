ActionController::Routing::Routes.draw do |map|
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
  
  map.root   :controller => 'home', :action => "index"
  map.login  '/login',  :controller => 'user_sessions', :action => 'new', :method => 'get'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy', :method => 'delete'
  
  map.resources :users, 
                :user_sessions,
                :email_templates,
                :organizations,
                :messages

  map.resources :mailouts do |message|
    message.resources :groups
    message.resources :recipients
  end
                
  map.resources :groups
  
  map.resources :attachments, { :member => 'thumbnail' }
  
  map.resources :recipients, { :member => 'black_list', :method => 'delete' } do |recipient|
    recipient.resources :groups
  end
  
end
