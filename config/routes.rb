Addressbook::Application.routes.draw do
  scope "(:locale)",
      :locale =>  /en|ru/ do

    resources :contacts do
      collection do
        get :export
        get :import
        post :upload
      end
    end

    resources :password_resets, :only => [ :new, :create, :edit, :update ]

    match "activate/:code" => "activations#create", :as => :activate

    match 'signup' => 'users#new', :as => :signup
    match 'logout' => 'user_sessions#destroy', :as => :logout
    match 'login' => 'user_sessions#new', :as => :login

    match '/auth/:provider/callback' => 'user_oauth#create', :as => :callback
    match '/auth/failure' => 'user_oauth#failure', :as => :failure

    resources :user_sessions

    resources :users

    root :to => 'contacts#index'

  end

  match '/auth/facebook' => 'user_oauth#create', :as => :fb_login
  #match '/auth/twitter' => 'user_oauth#create', :as => :tw_login

end
