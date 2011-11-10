class PackagesController < ApplicationController
  menu_item 'packages'
  def index
    submenu_item 'packages-index'
    @packages=@operator.packages.all(:order=>"id asc")
  end

#  def create
#      submenu_item 'packages-new'
#      @package=@operator.packages.new(params[:package])
#      if @package.save
#        flash[:notice]="添加成功。"
#        redirect_to :action => "index"
#      else
#        render :action=>:edit
#      end
#  end
#
#
#  def edit
#    submenu_item 'packages-index'
#    @package=Package.find(params[:id])
#  end
#
  def show
    submenu_item 'packages-index'
    @package=Package.find(params[:id])
  end
#
#  def new
#    submenu_item 'packages-new'
#    @package=@operator.packages.new
#    render :action=>:edit
#  end
#
#  def update
#    submenu_item 'packages-new'
#    @package=Package.find(params[:id])
#    if @package.update_attributes(params[:package])
#      redirect_to :action => "index"
#    else
#      render :action => :edit
#    end
#  end
#
#  def destroy
#    package=Package.find(params[:id])
#    package.destroy
#    flash[:notice] = "套餐删除成功。"
#    respond_to do |format|
#      format.html { redirect_to(packages_url) }
#      format.xml  { head :ok }
#    end


#  end

end
