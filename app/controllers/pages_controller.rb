class PagesController < ApplicationController
  filter_resource_access
  # GET /pages
  # GET /pages.xml
  # def index
  #   @pages = Page.all
  # 
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render :xml => @pages }
  #   end
  # end

  # GET /pages/1
  # GET /pages/1.xml
  # def show
  #   @page = Page.find(params[:id])
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.xml  { render :xml => @page }
  #   end
  # end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @chapter = Chapter.find(params[:chapter_id])
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
    @chapter = Chapter.find(params[:chapter_id])
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.xml
  def create
    @chapter = Chapter.find(params[:chapter_id])
    @story = @chapter.story
    @previous_page = @story.pages.first(:order => 'page_number DESC')
    page_number = @previous_page.page_number if @previous_page
    @page = Page.new(params[:page])
    @page.chapter_id = @chapter.id
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
    redirect_to @chapter.story
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @chapter = Chapter.find(params[:chapter_id])
    @page = Page.find(params[:id])

    if @page.update_attributes(params[:page])
      flash[:notice] = 'Page was successfully updated.'
    else
      flash[:error] = 'Page was not updated.'
    end
    
    redirect_to @chapter.story  
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    redirect_to @page.chapter.story
  end
end
