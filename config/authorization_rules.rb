authorization do
  role :guest do
    
  end
  
  role :user do
    has_permission_on :tables, :to => [:create]
    has_permission_on :tables, :to => [:read]
    
    has_permission_on :tables, :to => [:update] do
      if_attribute :user => is { user }
    end
    
  end
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
