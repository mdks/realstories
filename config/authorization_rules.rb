authorization do
  role :admin do
    has_permission_on :stories, :to => [:index, :show, :new, :create, :edit, :update, :destroy, :vote]
    has_permission_on :comments, :to => [:edit, :update, :create, :destroy]
  end
  
  role :guest do
    has_permission_on :stories, :to => [:index, :show]
  end
  
  role :normal do
    includes :guest
    has_permission_on :stories, :to => [:new, :create, :vote]
    has_permission_on :stories, :to => [:edit, :update] do
      if_attribute :user => is { user }
    end
    has_permission_on :comments, :to => :create
    has_permission_on :comments, :to => [:edit, :update, :destroy] do
      if_attribute :user => is { user }
    end
  end
  
end