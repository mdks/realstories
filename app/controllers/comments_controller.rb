class CommentsController < ApplicationController
  filter_resource_access

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])
    
    @comment.user_id = current_user.id
    @comment.story_id = params[:story_id]
    @comment.score = 0
    

    if @comment.save
      flash[:notice] = 'Comment posted.'
    else
      flash[:error] = 'Comment failed to post.'
    end
    
    redirect_to(@comment.story)
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment edited.'
      else
        flash[:error] = "Edit failed."
      end

    redirect_to(@comment.story)
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    redirect_to(@comment.story)
  end
end
