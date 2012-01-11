authorization do
  role :guest do
    
  end
  
  role :user do
    has_permission_on :daily_tables, :to => [:create]
    has_permission_on :daily_tables, :to => [:show]
    
    has_permission_on :daily_tables, :to => [:update] do
      if_attribute :user => is { user }
    end
    
    has_permission_on :daily_tables, :to => [:report] do
      if_permitted_to :show
    end
    
    has_permission_on :daily_reports, :to => [:create] do
      if_permitted_to :report, :table
    end
    
    has_permission_on :daily_reports, :to => [:update] do
      if_attribute :user => is { user }
    end
    
    has_permission_on :daily_reports, :to => [:show, :generate] do
      if_permitted_to :update
    end
    
    has_permission_on :daily_users, :to => [:update, :account] do
      if_attribute :id => is { user.id }
    end
    
  end
  
  role :admin do
    has_permission_on :daily_tables, :to => :manage
    has_permission_on :daily_reports, :to => :manage
    has_permission_on :daily_users, :to => :manage
  end
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
