class UserSessionsController < ApplicationController
  before_filter :require_user, :except => [:index, :create]
  
  def index
		# this is where RPX will return to if the user cancelled the login process
		redirect_to root_url #current_user ? root_url : new_user_session_url
	end
  
	# legacy login
  # def new
  #   @user_session = UserSession.new
  # end
  
	def create
		@user_session = UserSession.new(params[:user_session])
		if @user_session.save
			if @user_session.new_registration?
				flash[:notice] = "Welcome! As a new user, please review your registration details before continuing.."
				redirect_to edit_user_path( :current )
			else
				if @user_session.registration_complete?
					flash[:notice] = "Successfully signed in."
					redirect_to root_url
				else
					flash[:notice] = "Welcome back! Please complete required registration details before continuing.."
					redirect_to edit_user_path( :current )
				end
			end
		else
			flash[:notice] = "Failed to login or register."
			redirect_to root_url #new_user_session_path
		end
	end
    
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end
end
