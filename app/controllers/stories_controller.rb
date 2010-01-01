require "#{RAILS_ROOT}/lib/statistics2"
class StoriesController < ApplicationController
  load_and_authorize_resource

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
    # get chapter
    if params[:chapter_number]
      @chapter = @story.chapters.find_by_chapter_number(params[:chapter_number])
      @page = @chapter.pages.first(:order => 'page_number ASC')
    elsif params[:page_number]
      @page = @story.pages.find_by_page_number(params[:page_number])
      @chapter = @page.chapter
    else
      @chapter = @story.chapters.first(:order => 'chapter_number ASC')
      @page = @chapter.pages.first(:order => 'page_number ASC') if @chapter
    end
    # get next and previous page
    if @page
      @previous_page = @story.pages.find_by_page_number(@page.page_number - 1)
      @next_page = @story.pages.find_by_page_number(@page.page_number + 1)
      @page_content = RedCloth.new(@page.body, [:filter_styles, :filter_classes, :filter_ids]).to_html
    end
    unless @story.disable_commenting
      @comment = Comment.new
      @comments = @story.comments.find(:all, :order => "score desc")
    end
    respond_to do |format|
      format.html # show.html.erb
      #format.xml  { render :xml => @story }
      #format.atom
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
  #def edit
  #end

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
    @story.comments.destroy_all
    @story.pages.destroy_all
    @story.chapters.destroy_all #unless @story.chapters.nil?
    @story.destroy
    respond_to do |format|
      format.html { redirect_to(stories_url) }
      format.xml  { head :ok }
    end
  end

  # add vote action
  def vote
    unless @story.disable_voting
      unless current_user.id == @story.user.id
        if params[:vote].to_i == 1 then
          current_user.vote_for(@story)
        else
          current_user.vote_against(@story)
        end
        # update ci score here
        @story.score = ci_lower_bound(@story.votes_for, @story.votes_count, 0.10)
        @story.save!
        flash[:notice] = "Thank you for voting."
      else
        flash[:error] = "Cannot vote on own story!"
      end
    else
      flash[:error] = "Sorry, voting has been disabled!"
    end
    redirect_to(@story)
  rescue
    flash[:error] = "Vote failed!"
    redirect_to(@story)
  end

  def remove_all_spam
    Comment.delete_all(["is_approved = ? AND story_id = ?", false, @story.id])
    flash[:notice] = "Deleted all unapproved comments."
    redirect_to(@story)
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

