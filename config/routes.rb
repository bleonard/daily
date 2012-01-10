Rails.application.routes.draw do
  
  scope "/#{DailyConfig.subdirectory}" do
    
    devise_for :users, :only => :sessions do
      get "login", :to => "devise/sessions#new"
      get "logout", :to => "devise/sessions#destroy"
      root :to => "devise/sessions#new"
    end
  
    match 'home' => 'main#home', :as => :user_root
  
    resources :tables do
      resources :reports do
        member do
          post :generate
        end
      end
    end
  
    resources :reports, :only => :index
  
    resources :users
    get "account", :to => "users#edit"
    
    get "files/*path", :to => "files#show", :format => false
  end
  
end
