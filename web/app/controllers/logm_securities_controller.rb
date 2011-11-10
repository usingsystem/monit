class LogmSecuritiesController < ApplicationController

  # GET /logm_securities
  # GET /logm_securities.xml

  menu_item 'settings'

  def index
    submenu_item "securities"
     params[:sort] ||= '-created_at'
     if !params[:sort].nil?
      if params[:sort][0] == 45
        sort = params[:sort][1,params[:sort].length-1]
        rise = "DESC"
      else
        sort = params[:sort]
        rise = "ASC"
      end
    end
  
    @logm_securities = LogmSecurity.paginate  :conditions=>{:user=>current_user.id},:page=>params[:page],:per_page=>30,:order => "#{sort} #{rise}"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @logm_securities }
    end
  end

end
