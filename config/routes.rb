Tree::Application.routes.draw do

  get "news/index"
  post 'news/topic' => 'news#topic_create'
  post 'news/notification' => 'news#notification_create'

  get "columns/index"
  get '/npo' => "columns#index"
  get "categories/search"
  #resources :categories, :only => [:show]

  get "/statics" => "statics#index"
  resources :branches, :only => [:index, :show]
  resources :titles
  resources :badges
  resources :reports
  resources :exports
  resources :words do
    resources :contents, :only => [:index]
  end
  resources :users do
    collection do
      get :app_tw_auth
      get :export
      get :import
    end
  end
  resources :leafs do
    resources :favs do
      collection do 
        post :create
        delete :destroy
      end
    end
  end

  match 'suggests/*title' => 'suggests#index'

  resources :hots

  get '/hots/move' => 'hots#move'


  resources :inquiries
  resources :vims
  resources :bookmarks
  resources :columns
  resources :feeds do
     get :sites, :on => :collection 
  end
  #resources :topics, :only => [:index]
  resources :topics, :path => 'topics'
  resources :histories, :only => [:index]
  #resources :notifications, :only => [:index]
  resources :notifications, :path => 'notifications'
  resources :tweets, :only => [:create]
  post 'urls' => 'urls#show'
  resources :payments, :only => [:create]

  # get '/auth/twitter/callback' => 'users#tw_callback'
  #   match '/auth/failure' => 'users#tw_callback_fail'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end
  
  devise_scope :user do
    delete "logout", :to => "devise/sessions#destroy"
    get 'home' => 'categories#index', :as => :new_user_session
  end

  get '/api' => 'index#api'
  get '/all_data' => 'index#all_data'
  get '/help' => 'index#help'
  get '/welcome' => 'index#welcome'
  # get '/logout' => 'users#logout'
  #get ':id' => 'itunes#show'
  get ':id' => 'categories#show'
  #root :to => 'index#index'
  #root :to => 'bookmarks#index'
  #root :to => 'columns#index'
  root :to => 'categories#index'
end
