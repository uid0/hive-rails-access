Hive13RailsAccess::Application.routes.draw do
  resources :guests

  get "home/about"

  get "home/help"

  get "home/contact"

  devise_for :members, :path_names => {
    :verify_authy => "/verify-token",
    :enable_authy => "/enable-two-factor",
    :verify_authy_installation => "/verify-installation"
  }

  resources :members 
  match "members/:id/lockouttoggle" => "members#lockout", :as => "lockout_member"
  match "members/:id/privacytoggle" => "members#setprivacy", :as => "privacy_member"
  
  resources :charges
  get 'members/checkin/:id', to: 'members#checkin'

  get "home/index"
  get "home/doortest"
  get "home/enrollcard"
  root :to => 'home#index'
  get '/auth/:provider/callback', to: 'home#fsqsave'
  match '/contact', :to => 'home#contact'
  match '/about',   :to => 'home#about'
  match '/help',    :to => 'home#help'
  match '/doortest',:to => 'home#doortest'
  match '/vendtest',:to => 'home#vendtest'
  match '/testtest', :to => 'home#testtest'
  match '/statusboard', :to => 'home#statusboard'

  get '/enrollcard/:card/go', to: 'members#enrollcard'
  get '/testcheck/:card/go', to: 'members#testcheck'
  get '/doorcheck/:card/:readcount/:opencount/go', to: 'members#cardcheck'
  get '/vendcheck/:card/go', to: 'members#vendcheck'

  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
