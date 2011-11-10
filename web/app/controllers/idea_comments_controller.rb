class IdeaCommentsController < ApplicationController

  layout 'welcome'
  before_filter :login_required


    # GET /ideas/new
  # GET /ideas/new.xml
  def new
    @idea_comment = IdeaComment.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @idea_comment }
    end
  end

  # POST /idea_comments
  # POST /idea_comments.xml
  def create
    @idea_comment = IdeaComment.new(params[:idea_comment])
    @idea_comment.user_id=current_user.id
    if @idea_comment.save
      flash[:notice]="评论发表成功"
      redirect_to :back
    else
      flash[:error]="发表内容不能为空"
      redirect_to :back
    end
  end


  # DELETE /idea_comments/1
  # DELETE /idea_comments/1.xml
  def destroy
    @idea_comment = IdeaComment.find(params[:id])
    if @idea_comment.destroy
      flash[:notice]="评论删除成功"
      redirect_to :back
    end
  end
end
