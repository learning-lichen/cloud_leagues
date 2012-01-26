CloudLeagues::Application.routes.draw do
  get 'login' => 'user_sessions#new', :as => :login
  post 'login' => 'user_sessions#create'
  get 'logout' => 'user_sessions#destroy', :as => :logout

  resources :users do
    resource :account_information, :as => :profile, :path => :profile
  end

  root :to => 'home#index'
end
