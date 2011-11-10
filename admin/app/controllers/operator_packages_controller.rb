class OperatorPackagesController < ApplicationController
  menu_item 'operators'
  def index
    submenu_item 'operator-index'
    @operator=Operator.find(params[:operator_id])
    @packages=@operator.packages.all(:order=>"id asc")
  end

  def create
      @package=@operator.packages.new(params[:package])
      if @package.save
        flash[:notice]="添加成功。"
        redirect_to :action => "index"
      else
        render :action=>:edit
      end
  end


  def edit
    submenu_item 'operator-index'
    @operator=Operator.find(params[:operator_id])
    @package=@operator.packages.find(params[:id])
   
  end

  def update
    pp params
    submenu_item 'operator-index'
    @operator=Operator.find(params[:operator_id])
    @package=@operator.packages.find(params[:id])
    if @package.update_attributes(params[:package])
      flash[:notice]="修改成功！"
      redirect_to operator_packages_path(@operator)
    else
      render :action => :edit
    end
  end

  def show
  end

  def new
    @package=@operator.packages.new
    render :action=>:edit
  end

  def destroy
    package=Package.find(params[:id])
    package.destroy
    flash[:notice] = "套餐删除成功。"
    respond_to do |format|
      format.html { redirect_to(packages_url) }
      format.xml  { head :ok }
    end


  end

end
