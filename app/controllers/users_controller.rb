class UsersController < ApplicationController

  # must be the correct user to edit, update, destroy
  # or else i shit you back to the index, logged in or not
  before_filter :check_user, :only => [:edit, :update, :destroy]
  
  # GET /users
  # GET /users.xml
  # Admins only
  def index
    # unless User.find(session[:user_id]).is_admin?
    #   redirect_to :controller => 'stories', :action => 'index'
    # end
    @users = User.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  # User profile
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  # TODO: Send activation code to email provided.
  def create
    @user = User.new(params[:user])

    respond_to do |format|
        if verify_recaptcha(@user) && @user.save
          send_activation_code(@user)
          flash[:notice] = "User #{@user.name} was successfully created."
          format.html { redirect_to(:controller => 'stories', :action=>'index') }
          format.xml  { render :xml => @user, :status => :created, :location => @user }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "User #{@user.name} was successfully updated."
        format.html { redirect_to(:controller => 'stories', :action=>'index') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  # TODO: Delete all of user's posts too.
  def destroy
    @user = User.find(params[:id])
    # destroy all stories!
    @user.stories.destroy_all
    # destroy user record!
    @user.destroy
    # log out!
    session[:user_id] = nil if session[:user_id].to_i == params[:id].to_i

    respond_to do |format|
      format.html { redirect_to(:controller => 'stories', :action=>'index') }
      format.xml  { head :ok }
    end
  end
  
  # Forgot password code
  # Creates a reset code, saves it and then passes it to the ActionMailer
  # TODO: Change Reset Code format
  def forgot_password
    user = User.find_by_email(params[:email])
    if (user) 
      user.reset_password_code_until = 1.day.from_now
      user.reset_password_code =  Digest::SHA1.hexdigest( "#{user.email}#{Time.now.to_s.split(//).sort_by {rand}.join}" )
      user.save!
      UserNotifier.deliver_forgot_password(user)
      flash[:notice] = "Reset Password link emailed to #{user.email}"
      redirect_to :controller => 'stories', :action => 'index'
    else
      flash[:notice] = "User not found: #{user.email}"
      redirect_to :controller => 'stories', :action => 'index'
    end 
  end

  # Creates a user object from the reset code
  def reset_password
    user = User.find_by_reset_password_code(params[:reset_code])
    # Change this to actually log user in our way
    session[:user_id] = user.id if user && user.reset_password_code_until && Time.now < user.reset_password_code_until 
    # Change this, redirect properly
    redirect_to :controller => "users", :action => "edit", :id => user.id
  end
  
  def activate
    user = User.find_by_activation_code(params[:activation_code])
    user.is_activated = true
    user.save!
    flash[:notice] = "Thanks for activating your account, #{user.name}"
    flash[:notice] += " You may now log in."
    redirect_to :controller => 'access', :action => 'login'
  end   
  
  private
  
    # called by create
    def send_activation_code(user)
      user.is_activated = false
      user.activation_code = Digest::SHA1.hexdigest( "#{user.email}#{Time.now.to_s.split(//).sort_by {rand}.join}" + "lol" )
      user.save!
      UserNotifier.deliver_activation_code(user)  
    end
    
    def check_user
      unless session[:user_id].to_i == params[:id].to_i  || User.find(session[:user_id]).is_admin?
        redirect_to :controller => 'stories', :action => 'index'
      end
    end
  
end
