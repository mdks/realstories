class ChaptersController < ApplicationController
  filter_resource_access

  # GET /chapters/new
  # GET /chapters/new.xml
  def new
    @story = Story.find(params[:story_id])
    @chapter = Chapter.new
  end

  # GET /chapters/1/edit
  def edit
    @story = Story.find(params[:story_id])
    @chapter = Chapter.find(params[:id])
  end

  # POST /chapters
  # POST /chapters.xml
  def create
    @story = Story.find(params[:story_id])
    @previous_chapter = @story.chapters.first(:order => 'chapter_number DESC')
    chapter_number = @previous_chapter.chapter_number if @previous_chapter
    @chapter = Chapter.new(params[:chapter])
    @chapter.story_id = @story.id
    if chapter_number
      @chapter.chapter_number = chapter_number + 1
    else
      @chapter.chapter_number = 1
    end 
    if @chapter.save
      flash[:notice] = 'Chapter was successfully created.'
    else
      flash[:notice] = 'Chapter was successfully created.'
    end
    redirect_to @story
  end

  # PUT /chapters/1
  # PUT /chapters/1.xml
  def update
    @story = Story.find(params[:story_id])
    @chapter = Chapter.find(params[:id])

    if @chapter.update_attributes(params[:chapter])
      flash[:notice] = 'Chapter was successfully updated.'
    else
      flash[:error] = 'Chapter was not updated.'
    end
    redirect_to @story
  end

  # DELETE /chapters/1
  # DELETE /chapters/1.xml
  def destroy
    @story = Story.find(params[:story_id])
    @chapter = Chapter.find(params[:id])
    @chapter.pages.destroy_all
    @chapter.destroy
    redirect_to @story
  end
end
