class TenantsController < ApplicationController
  menu_item 'tenants'
  skip_before_filter :login_required, :only=>["plans"]
  def index
    package_tab
    sort=parse_sort params[:sort]
    con=if @free && @free.operator_id == 0 && @free.id.to_s==params[:package_id]
      ["operator_id=? and package_id = ? or package_id is null",@operator.id,params[:package_id]]
    elsif params[:package_id]
      ["operator_id=? and package_id = ?",@operator.id,params[:package_id]]
    else
      ["operator_id=?",@operator.id]
    end
    @tenants=Tenant.order(sort).paginate(:page=>params[:page],:conditions=>con,:include=>"package")
 
  end

  def plans
    render :layout=>"welcome"
  end

  def show
    
  end

  def package_tab
    stat=@operator.tenants.all :select=>"package_id,count(*) num",:group=>"package_id"
   
    @status_tab = {}
    @operator.packages.each do |p|
      @free=p if p.category == 0
      @status_tab[p.id]=[p.id,p.name, 0, filter_params(params, {:package_id => p.id}),p.id]
    end
    n = 0
    stat.each do |s|
      if @free && s.package_id == nil
      
        @status_tab[@free.id][2] += s.num.to_i
      elsif s.package_id != nil
       
        @status_tab[s.package_id][2] += s.num.to_i

      end
      n = n + s.num.to_i
    end
   
    @status_tab["all"]= ["all",t('all'), n, filter_params(params, {:package_id => nil}),-1]

    @current_status_name = params[:package_id].blank? ? 'all' : params[:package_id]
  end
end
