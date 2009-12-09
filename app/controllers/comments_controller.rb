require "#{RAILS_ROOT}/lib/statistics2"
class CommentsController < ApplicationController

  has_rakismet :only => :create
  filter_resource_access

  # GET /comments/1/edit
  def edit
    if Story.find(params[:story_id]).disable_commenting
      flash[:error] = "Commenting has been disabled for this story."
      redirect_to(Story.find(params[:story_id]))
    end
  end

  # POST /comments
  # POST /comments.xml
  def create
    story = Story.find(params[:story_id])
    unless story.disable_commenting
      @comment.user_id = current_user.id
      @comment.story_id = params[:story_id]
      @comment.score = 0
      
      # Akismet hook
      if !@comment.spam? : @comment.is_approved = true else @comment.is_approved = false end
      
      @comment.save
  
      if @comment.is_approved
        flash[:notice] = 'Comment posted.'
      else
        flash[:error] = 'Comment marked as spam please contact an administrator.'
      end   
    else
      flash[:error] = "Commenting has been disabled for this story."
    end
      redirect_to(story)
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    story = Story.find(params[:story_id])
    unless story.disable_commenting
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment edited.'
      else
        flash[:error] = "Edit failed."
      end
    else
      flash[:error] = "Commenting has been disabled for this story."
    end

    redirect_to(story)
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment.destroy

    redirect_to(@comment.story)
  end
  
  def vote
    unless current_user.id == @comment.user.id
      if params[:vote].to_i == 1 then
        current_user.vote_for(@comment)
      else
        current_user.vote_against(@comment)
      end
      @comment.score = ci_lower_bound(@comment.votes_for, @comment.votes_count, 0.10)
      @comment.save!
      flash[:notice] = "Thanks for voting."
    else
      flash[:error] = "Cannot vote on own comment!"
    end
    redirect_to(@comment.story)
  rescue
    flash[:error] = "Can only vote once!"
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
