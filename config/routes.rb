Addressbook::Application.routes.draw do
  scope "(:locale)",
      :locale =>  /en|ru/ do

    resources :contacts

    resources :password_resets, :only => [ :new, :create, :edit, :update ]

    match "activate/:code" => "activations#create", :as => :activate

    match 'signup' => 'users#new', :as => :signup

    match 'logout' => 'user_sessions#destroy', :as => :logout

    match 'login' => 'user_sessions#new', :as => :login

    resources :user_sessions

    resources :users

    root :to => 'contacts#index'

  end


end
