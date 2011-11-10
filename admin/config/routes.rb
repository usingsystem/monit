ActionController::Routing::Routes.draw do |map|
  map.connect '/dashboard/summary.:format',:controller=>'dashboard',:action=>'summary'
  
  map.plans '/plans',:controller=>'tenants',:action=>'plans'
  map.dashboard '/dashboard', :controller => 'dashboard', :action => 'index'

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login  '/login', :controller => 'sessions', :action => 'new'
  map.signup '/signup', :controller => 'operators', :action => 'new'
  map.resource :session

  map.resources :services,:collection=>{:summary=>:get}
  map.resources :tenants
  map.resources :orders,:member=>{:pay=>:put}
  map.resources :bills
  map.resources :operators,:member=>{:confirm=>:get,:recharge=>[:post,:get]} do |operator|
      operator.resources   :packages,:controller=>"operator_packages"
  end
  map.resources :ideas

  map.root :controller => 'dashboard', :action => 'index'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
