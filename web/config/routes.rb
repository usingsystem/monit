ActionController::Routing::Routes.draw do |map|
  map.resources :bills

  map.resources :stat, :controller => "stat", :collection => {:status => :get, :services => :get}

  map.resources :orders, :collection => { :return => :get, :notify => :post }
  map.resources :packages

  #map.resources :views

  map.resources :logm_securities

  map.resource :feedback
  #map.feedback '/feedback', :controller => 'feedbacks', :action => 'new'
  #map.create_feedback '/feedback/create', :controller => 'feedbacks', :action => 'create'

  map.resources :ideas
  map.resources :idea_comments
  map.resources :groups
  map.resources :notifications

  map.root :controller => 'welcome', :action => 'index'
  map.contact '/contact', :controller => 'welcome', :action => 'contact'
  map.terms '/terms', :controller => 'welcome', :action => 'terms'
  map.about '/about', :controller => 'welcome', :action => 'about'
  map.jobs '/jobs', :controller => 'welcome', :action => 'jobs'
  map.plans "/plans",:controller=>'packages', :action=>'plans'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'accounts', :action => 'activate', :activation_code => nil
  map.register '/register', :controller => 'accounts', :action => 'create'
  map.signup '/signup/:package_id', :controller => 'accounts', :action => 'new',:defaults => {:package_id => nil}
  map.dashboard '/dashboard', :controller => 'dashboard', :action => 'index'
  map.search '/search/:q', :controller => 'search', :action => 'index'

  map.resources :users , :collection => {:summary => :get}
  map.resource :session
  map.resource :tenant, :member => { :to_free => :post }
  map.resource :account, :collection => {:resend_password => [:get, :post], :reset_password => [:get, :put], :password => :get, :update_password => :put, :setting => :get, :report => :get, :update_report => :put}
  map.reset_password 'account/reset_password/:reset_password_code', :controller => 'accounts', :action => 'reset_password'
  map.resources :ui, :collection => { :index => :get, :form => :get }

  map.resources :plugins

  map.resources :agents, :member => { :confirm => :get }

  map.resources :services, :member => {:history => :get }, :collection => { :types => :get, :select => :get, :disco => :get, :create_from_disco => :post , :destroy_disco => :delete, :create_all_disco => :get, :destroy_all_disco => :get, :summary => :get, :edit_notification => :get, :edit_threshold => :get, :batch_update => :put } do |service|
    service.resources :views, :member => { :data => :get }
    service.resource :avail, :controller => "avail"
  end

  map.resources :hosts, :member => { :live => :get, :view => :get, :confirm => :get, :test_snmp => :post, :disco => :get, :redisco => :put, :ctrl => :get, :ctrl_update => :put ,:config => :get}, :collection => {:select => :get, :edit_notification => :get, :batch_update => :put } do |host|
    host.resources :services, :collection => {:types => :get, :select => :get}
    host.resource :avail, :controller => "avail"
  end

  map.resources :devices, :member => {:confirm => :get, :test_snmp => :post, :disco => :get, :redisco => :put, :ctrl => :get, :ctrl_update => :put }, :collection => {:select => :get, :edit_notification => :get, :batch_update => :put} do |device|
    device.resources :services, :collection => {:types => :get, :select => :get}
    device.resource :avail, :controller => "avail"
  end

  map.resources :apps, :member => {:confirm => :get, :ctrl => :get, :ctrl_update => :put,:config => :get}, :collection => {:types => :get, :edit_notification => :get, :batch_update => :put}  do |app|
    app.resources :services, :collection => {:types => :get, :select => :get, :summary => :get}
    app.resource :avail, :controller => "avail"
  end

  map.resources :sites, :member => {:confirm => :get, :ctrl => :get, :ctrl_update => :put }, :collection => {:edit_notification => :get, :batch_update => :put}  do |site|
    site.resources :services, :collection => {:types => :get, :select => :get}
    site.resource :avail, :controller => "avail"
  end

  map.resources :app_types do |type|
    type.resource :top, :controller => "top"
  end

  map.resources :host_types do |type|
    type.resource :top, :controller => "top"
  end

  map.resources :device_types do |type|
    type.resource :top, :controller => "top"
  end

  map.resources :service_types do |type|
    type.resources :metrics, :controller => "metrics" do |m|
      m.resource :top, :controller => "top"
    end
    type.resource :top, :controller => "top"
  end

  map.resources :alerts, :collection => {}
  map.resources :business, :collection => { :physics => :get, :automap => :get }
  #map.resources :reports, :collection => { :top => :get }
  map.purchase '/reports/top', :controller => 'welcome', :action => 'test'
  map.resources :service_types, :collection => { :app_host => :get }
  map.resources :service_params
  map.resources :host_types
  map.resources :themes, :collection => {:steelblue => :get}
  map.resources :admin
  map.resource :avail, :controller => :avail, :collection => {:sites => :get, :devices => :get, :apps => :get, :hosts => :get, :services => :get}
  map.resources :top, :controller => :top, :collection => {:sites => :get, :devices => :get, :apps => :get, :hosts => :get, :services => :get}

#  map.resources :host, :controller => :host_topn, :collection => {:top=>:get}
#  map.resources :site, :controller => :site_topn, :collection => {:top=>:get}

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
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
