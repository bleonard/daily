Rails.application.routes.draw do
  
  scope "/#{DailyConfig.subdirectory}" do
    
    devise_for :users, :only => :sessions, :class_name => "DailyUser" do
      get "login", :to => "devise/sessions#new"
      get "logout", :to => "devise/sessions#destroy"
      root :to => "devise/sessions#new"
    end
  
    match 'home' => 'main#home', :as => :user_root
  
    resources :daily_tables, :path => "tables" do
      member do
        get :archive
        post :archiveit
        post :unarchiveit
      end
      resources :daily_reports, :path => "reports" do
        member do
          post :generate
          post :archiveit
          post :unarchiveit
        end
      end
    end
  
    resources :daily_reports, :path => "reports", :only => :index
  
    resources :daily_users, :path => "users"
    get "account", :to => "daily_users#edit"
    
    get "files/*path", :to => "files#show", :format => false
  end
  
end
