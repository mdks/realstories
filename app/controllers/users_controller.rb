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
            flash[:notice] = "Successfully edited profile."
            redirect_to root_url
          else
            render :action => 'edit'
          end
  end

  def ban
    @user = User.find(params[:user_id])
    # user never existed, but can't login anymore
    @user.stories.each do |story|
      story.pages.destroy_all
      story.chapters.destroy_all
      story.comments.destroy_all
      story.votes.destroy_all
    end
    @user.stories.destroy_all
    @user.is_banned = true
    if @user.save
      flash[:notice] = "User was banned."
    else
      flash[:error] = "Error banning user."
    end
    redirect_to root_url
  end

  def upgrade
    # lemme upgrade u
    @user = User.find(params[:user_id])
    @user.is_pro = true
    if @user.save
      flash[:notice] = "User was upgraded."
    else
      flash[:error] = "Error upgrading user."
    end
    redirect_to root_url
  end

end
