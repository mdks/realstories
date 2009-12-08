class CommentsController < ApplicationController
  has_rakismet :only => :create
  filter_resource_access

  # GET /comments/1/edit
  # def edit
  # end

  # POST /comments
  # POST /comments.xml
  def create
    @comment.user_id = current_user.id
    @comment.story_id = params[:story_id]
    @comment.score = 0
    
    # Akismet hook
    if !@comment.spam? : @comment.is_approved = 1 end
    
    @comment.save

    if @comment.is_approved
      flash[:notice] = 'Comment posted.'
    else
      flash[:error] = 'Comment marked as spam please contact an administrator.'
    end
    
    redirect_to(@comment.story)
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
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
    @comment.destroy

    redirect_to(@comment.story)
  end
  
  def spam
    @comment.spam!
    @comment.is_approved = 0
    @comment.save
    flash[:notice] = "Marked as spam."
    redirect_to(@comment.story)
  end
  
  def ham
    @comment.ham!
    @comment.is_approved = 1
    @comment.save
    flash[:notice] = "Marked as ham."
    redirect_to(@comment.story)
  end
  
  def remove_all_spam
    
  end
end
