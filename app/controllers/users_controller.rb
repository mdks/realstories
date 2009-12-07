class UsersController < ApplicationController
  
  before_filter :require_user

  # GET /users/1/edit
  # edit profile and register
  def edit
    @user = current_user
    @user.valid?
  end

  # PUT /users/1
  # PUT /users/1.xml
  # saves auto-register
  def update
          @user = current_user
          @user.attributes = params[:user]
          
          if @user.save
            #@user.assignments.create(:user_id => @user.id, :role_id => Role.find_by_name("normal").id)
            @user.roles.create(:name => "normal")
            flash[:notice] = "Successfully edited profile."
            redirect_to root_url
          else
            render :action => 'edit'
          end
  end

end
