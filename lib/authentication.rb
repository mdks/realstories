module Authentication
  
  def self.included(controller)
    controller.send :helper_method, :current_user, :logged_in?, :redirect_back_or_default
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "Please log in"
      redirect_back_or_default root_url
      return false
    end
  end

  def logged_in?
    current_user
  end

  # TODO: use functions below this line

  def clear_location
    session[:return_to] = nil
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  private
  
  def store_location
    session[:return_to] = request.request_uri
  end
end