class LogmOperationsController < ApplicationController
  # GET /logm_operations
  # GET /logm_operations.xml
  menu_item 'settings'
  def index
    submenu_item 'logm-operations'
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
    @logm_operations = LogmOperation.paginate :conditions=>{:user_id=>current_user.id} ,:page=>params[:page],:per_page=>30,:order => "#{sort} #{rise}"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @logm_operations }
    end
  end


end