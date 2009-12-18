authorization do
  role :admin do
    has_permission_on :stories, :to => [:index, :show, :new, :create, :edit, :update, :destroy, :vote, :remove_all_spam]
    has_permission_on :comments, :to => [:edit, :update, :create, :destroy, :spam, :ham, :vote]
    has_permission_on :chapters, :to => [:new, :create, :edit, :update, :destroy]
    has_permission_on :pages, :to => [:new, :create, :edit, :update, :destroy]
    
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
    has_permission_on :chapters, :to => [:new, :create]
    has_permission_on :chapters,[:edit, :update, :destroy] do
      if_attribute :user => is { user }
    end
    has_permission_on :pages, :to => [:new, :create]
    has_permission_on :pages, :to => [:edit, :update, :destroy] do
      if_attribute :user => is { user }
    end
    has_permission_on :comments, :to => [:create, :vote]
    has_permission_on :comments, :to => [:edit, :update, :destroy] do
      if_attribute :user => is { user }
    end
  end
  
end