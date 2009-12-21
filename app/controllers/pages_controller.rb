class PagesController < ApplicationController
  load_and_authorize_resource :nested => :chapter
  # GET /pages/new
  # GET /pages/new.xml
  def new
    @content_submission = true
    @chapter = Chapter.find(params[:chapter_id])
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
    @content_submission = true
    @chapter = Chapter.find(params[:chapter_id])
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.xml
  def create
    # get chapter
    @chapter = Chapter.find(params[:chapter_id])
    # get story
    @story = @chapter.story
    # update story
    @story.updated_at = Time.now
    @story.save
    # get highest page #
    @previous_page = @story.pages.first(:order => 'page_number DESC')
    # set page_number variable
    page_number = @previous_page.page_number if @previous_page
    # create new page
    @page = Page.new(params[:page])
    # remove images
    unless current_user.is_pro || current_user.is_admin
      @page.body.gsub!(/^\![^!]*\!/, "Please donate to post images!")
    end
    # set chapter id
    @page.chapter_id = @chapter.id
    # set page number
    if page_number
      @page.page_number = page_number + 1
    else
      @page.page_number = 1
    end 
    if @page.save
      flash[:notice] = 'Page was successfully created.'
    else
      flash[:error] = 'Page was not created.'
    end
    redirect_to page_path(@story, @page.page_number)
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @chapter = Chapter.find(params[:chapter_id])
    @story = @chapter.story
    @story.updated_at = Time.now
    @story.save
    @page = Page.find(params[:id])
    # remove images
    unless current_user.is_pro || current_user.is_admin
      params[:page][:body].gsub!(/^\![^!]*\!/, "Please donate to post images!")
    end
    if @page.update_attributes(params[:page])
      flash[:notice] = 'Page was successfully updated.'
    else
      flash[:error] = 'Page was not updated.'
    end
    
    redirect_to page_path(@story, @page.page_number) 
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    @story = @page.chapter.story
    @chapter = @page.chapter
    @page.destroy
    # renumber pages
    @pages = @story.pages.all(:order => "page_number asc")
    i = 0
    @pages.each do |page|
      i += 1
      page.page_number = i
      page.save!
    end
    redirect_to chapter_path(@story, @chapter.chapter_number)
  end

  # parse textile
  def parse_textile
   render :text => RedCloth.new(params[:data]).to_html
  end

end
