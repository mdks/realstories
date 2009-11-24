class AccessController < ApplicationController
  layout 'users'
  # authenticates user and stores their id in the session
  # then redirects them to their original URL or home
  # TODO: disallow login for unactivated user
  def login
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        if user.is_activated?
          session[:user_id] = user.id
          uri = session[:original_uri]
          session[:original_uri] = nil
          redirect_to(uri || { :controller => "stories", :action => "index" })
        else
          flash.now[:notice] = "Please activate your account before logging in."
        end
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end

  # destroys the user id in the session
  # effectively logging user out

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:controller => "stories", :action => "index")
  end

end
