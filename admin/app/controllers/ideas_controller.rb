class IdeasController < ApplicationController
  layout 'welcome'
  before_filter :login_required

  # GET /ideas
  # GET /ideas.xml
  def index
    idea_type

    params[:type_id]||=0
    params[:order] ||="recent"

    @ideas=Idea.find_categories(params[:type_id],params[:page],params[:order])
    @idea = Idea.new(:type_id => params[:type_id].to_i)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ideas }
    end
  end

  # GET /ideas/1
  # GET /ideas/1.xml
  def show
    idea_type
    @idea_id=params[:id]
    @idea = Idea.find_idea(params[:id])
    @idea_comments=IdeaComment.paginate query(:page=>params[:page])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @idea }
    end
  end

  # GET /ideas/new
  # GET /ideas/new.xml
  def new
    @idea = Idea.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @idea }
    end
  end

  # GET /ideas/1/edit
  def edit
    idea_type
    @idea = Idea.find(params[:id])
  end

  # POST /ideas
  # POST /ideas.xml
  def create
    @idea=Idea.new(params[:idea])
    @idea.user_id=current_user.id
    if @idea.save
      IdeaVote.save_vote(@idea.id,"",0)
      flash[:notice] = "反馈成功"
      redirect_to :back
    else
      flash[:error]="标题或内容不能为空"
      redirect_to :back
    end
  end

  # PUT /ideas/1
  # PUT /ideas/1.xml
  def update
    @idea = Idea.find(params[:idea][:id])
    if @idea.update_attributes(params[:idea])
      redirect_to :action=>:index
    else
      flash[:error]="修改后标题或内容不能为空"
      redirect_to :action => "edit", :id => @idea.id
    end
  end

    def argee_vote
    if IdeaVote.save_vote(params[:idea_id],current_user.id,1)
      flash[:notice]="投票成功"
      redirect_to :back
    else
      redirect_to :back
    end
  end

   def dis_vote
    if IdeaVote.save_vote(params[:idea_id],current_user.id,-1)
      flash[:notice]="投票成功"
      redirect_to :back
    else
      redirect_to :back
    end
  end

  def idea_type
    @idea_types=IdeaType.find_by_sql("select t1.id,t1.name,count(t2.type_id) num from idea_types t1 left join ideas t2 on t1.id=t2.type_id group by t1.id")
  end

   private
   
   def query options = {}
    order_option options
    con = conditions
    con.update :idea_id => params[:id] unless params[:id].blank?
    options.update({
      :select =>'idea_comments.*',
      :conditions => con
    })
  end

  def conditions con = {}
    con.update :idea_id => params[:id]
    con
  end

end
