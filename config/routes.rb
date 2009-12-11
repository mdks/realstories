ActionController::Routing::Routes.draw do |map|
  
  # login/logout routes
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.resources :user_sessions
  
  map.resources :users

  # voting routes
  map.vote '/stories/:id/vote/:vote', :controller => 'stories', :action => 'vote'
  map.vote_comment '/comments/:id/vote/:vote', :controller => 'comments', :action => 'vote'
  # sorting, with time
  map.sort '/stories/sort/:order/:sort/:time', :controller => 'stories', :action => 'index'
  map.connect '/stories/sort/:order/:sort/:time.:format', :controller => 'stories', :action => 'index'
  # stories, chapters and comments
  map.resources :stories do |story|
    story.resources :comments, :only => [:edit, :update, :create, :destroy]
    story.resources :chapters, :only => [:new, :create, :edit, :update, :destroy] 
  end
  map.resources :chapters do |chapter|
    chapter.resources :pages, :only => [:new, :create, :edit, :update, :destroy]
  end
  map.spam 'spam/:id', :controller => 'comments', :action => 'spam'
  map.ham 'ham/:id', :controller => 'comments', :action => 'ham'
  map.remove_all_spam 'remove_all_spam/:id', :controller => 'stories', :action => 'remove_all_spam'

  # chapter route
  map.chapter '/stories/:id/chapters/:chapter_number', :controller => 'stories', :action => 'show'
  # page route
  map.page '/stories/:id/pages/:page_number', :controller => 'stories', :action => 'show'
  
  # root route
  map.root :controller => "stories"

end
