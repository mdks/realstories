require "#{RAILS_ROOT}/lib/statistics2"
class StoriesController < ApplicationController
  filter_resource_access
  
  before_filter :require_user, :except => [:index, :show]
  
  # GET /stories
  # GET /stories.xml
  def index
    
    # sorting
    if params[:order]
      # get time
      if params[:time] == "today"
        time = (Time.now - 1.day).utc
      elsif params[:time] == "week"
        time = (Time.now - 7.days).utc
      elsif params[:time] == "month"
        time = (Time.now - 1.month).utc
      else
        # TODO: Generate a date from 01-01-2009
        time = Time.utc(2009, 01, 01)
      end
      # ci score sorting
      if params[:order] == "best"
        # Order by Score
        # Descending
        if params[:sort] == "desc"
          @stories = Story.paginate(:page => params[:page], 
          :order => 'score DESC', :conditions => ["created_at >= ?", time])
        else
          @stories = Story.paginate(:page => params[:page], 
          :order => 'score ASC', :conditions => ["created_at >= ?", time])
        end  
      # date sorting  
      elsif params[:order] == "latest"
        # Order by Newest
         if params[:sort] == "desc"
          @stories = Story.paginate(:page => params[:page], 
          :order => 'created_at DESC', :conditions => ["created_at >= ?", time])
        else
          @stories = Story.paginate(:page => params[:page], 
          :order => 'created_at ASC', :conditions => ["created_at >= ?", time])
        end
      elsif params[:order] == "lastupdated"
        # Order by Last Updated
         if params[:sort] == "desc"
          @stories = Story.paginate(:page => params[:page], 
          :order => 'updated_at DESC', :conditions => ["updated_at >= ?", time])
        else
          @stories = Story.paginate(:page => params[:page], 
          :order => 'updated_at ASC', :conditions => ["updated_at >= ?", time])
        end
      # TODO: hits sorting
      #elsif params[:order] == "hot"
        # Order by Hits    
      end  
    else
      # no sorting
      @stories = Story.paginate(:page => params[:page])
    end
      
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stories }
      format.atom { render :layout => false }
    end
  end
  
  # GET /stories/1
  # GET /stories/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @story }
      format.atom
    end
  end
  
  # GET /stories/new
  # GET /stories/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @story }
    end
  end
  
  # GET /stories/1/edit
  def edit
  end
  
  # POST /stories
  # POST /stories.xml
  def create
    @story.user_id = current_user.id
    @story.score = 0
    
    respond_to do |format|
      # easily enable recaptcha
      #if verify_recaptcha(@story) && @story.save
      if @story.save
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
    @story.votes.destroy_all
    @story.destroy
    
    respond_to do |format|
      format.html { redirect_to(stories_url) }
      format.xml  { head :ok }
    end
  end
  
  # add vote action
  def vote
    @story = Story.find(params[:id])
    @user = current_user
    unless @user.id == @story.user.id
      if params[:vote].to_i == 1 then
        @user.vote_for(@story)
      else
        @user.vote_against(@story)
      end
      # update ci score here
      @story.score = ci_lower_bound(@story.votes_for, @story.votes_count, 0.10)
      @story.save!
    else
      flash[:notice] = "Cannot vote on own story!"
    end
    redirect_to :controller => 'stories', :action => 'show', :id => params[:id]
  rescue
    flash[:notice] = "You may only vote once!"
    redirect_to :controller => 'stories', :action => 'show', :id => params[:id]
  end
  
  private
  
    def ci_lower_bound(pos, n, power)
      if n == 0
        return 0
      end
      z = Statistics2.pnormaldist(1-power/2)
      phat = 1.0*pos/n
      (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)
    end

  
end
