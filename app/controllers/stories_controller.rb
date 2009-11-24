class StoriesController < ApplicationController

  # logged in
  before_filter :authorize, :except => [:index, :show]
  # authorized 
  before_filter :check_user, :except => [:index, :show, :new, :create]
  
  # GET /stories
  # GET /stories.xml
  def index
    @stories = Story.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stories }
      format.atom { render :layout => false }
    end
  end
  
  # GET /stories/1
  # GET /stories/1.xml
  def show
    @story = Story.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @story }
      format.atom
    end
  end
  
  # GET /stories/new
  # GET /stories/new.xml
  def new
    @story = Story.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @story }
    end
  end
  
  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
  end
  
  # POST /stories
  # POST /stories.xml
  def create
    @story = Story.new(params[:story])
    @story.user_id = session[:user_id]
    
    respond_to do |format|
      if verify_recaptcha(@story) && @story.save
        flash[:notice] = 'Story was successfully created.'
        format.html { redirect_to(@story) }
        format.xml  { render :xml => @story, :status => :created, :location => @story }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /stories/1
  # PUT /stories/1.xml
  def update
    @story = Story.find(params[:id])
    
    respond_to do |format|
      if @story.update_attributes(params[:story])
        flash[:notice] = 'Story was successfully updated.'
        format.html { redirect_to(@story) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /stories/1
  # DELETE /stories/1.xml
  def destroy
    @story = Story.find(params[:id])
    @story.destroy
    
    respond_to do |format|
      format.html { redirect_to(stories_url) }
      format.xml  { head :ok }
    end
  end
  
  # add vote action
  def vote
    @story = Story.find(params[:id])
    @user = User.find(session[:user_id])
    # unless @user.id == @story.user.id
      if params[:vote].to_i == 1 then
        @user.vote_for(@story)
      else
        @user.vote_against(@story)
      end
    # else
    #   flash[:notice] = "Cannot vote on own story!"
    # end
    redirect_to :controller => 'stories', :action => 'show', :id => params[:id]
  rescue
    flash[:notice] = "You may only vote once!"
    redirect_to :controller => 'stories', :action => 'show', :id => params[:id]
  end
  
  private
  
    def check_user
      unless session[:user_id].to_i == Story.find(params[:id]).user.id.to_i  || User.find(session[:user_id]).is_admin?
        redirect_to :controller => 'stories', :action => 'index'
      end
    end
  
end
