Radioactivemap::Application.routes.draw do

  resources :users, :key => :username
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :users do
    member do
      get :geigercounter
    end
  end

  resources :measurements

  resources :sessions,        :only => [:new, :create, :destroy]
  resources :measurements,    :only => [:create, :destroy]
  resources :relationships,   :only => [:create, :destroy]
  resources :geigercounters,  :only => [:create, :destroy]

  match '/signup',    :to => 'users#new'
  match '/signin',    :to => 'sessions#new'
  match '/signout',   :to => 'sessions#destroy'

  match '/contact',   :to => 'page#contact'
  match '/about',     :to => 'page#about'
  match '/home',      :to => 'page#home'
  match '/terms',     :to => 'page#terms'

  root :to => "page#home"

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
  

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

end