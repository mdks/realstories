authorization do
  role :admin do
    has_permission_on :stories, :to => [:index, :show, :new, :create, :edit, :update, :destroy]
  end
  
  role :guest do
    has_permission_on :stories, :to => [:index, :show]
  end
  
  role :normal do
    includes :guest
    has_permission_on :stories, :to => [:new, :create]
    has_permission_on :stories, :to => [:edit, :update] do
      if_attribute :user => is { user }
    end
  end
  
end