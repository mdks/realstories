# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  protected
    # if there is no user id in the session, user isnt logged in
    def logged_in?
      User.find_by_id(session[:user_id])
    end
    
    def authorize
      unless logged_in?
        session[:original_uri] = request.request_uri
        #flash[:notice] = "Please log in"
        redirect_to :controller => 'access', :action => 'login'
      end
    end
end
