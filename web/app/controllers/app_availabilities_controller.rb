class AppAvailabilitiesController < ApplicationController

  before_filter :login_required
  menu_item 'reports'
  def index
    submenu_item 'reports-availability'
    @date||= params[:date].nil? ? "last24hours":params[:date]
    @apps=App.all :conditions=>{:tenant_id => current_user.tenant_id}
    select_date(@date)

    @result=[]
    @apps.each do |app|
      status=app.status1
      @result << availablities(status,app) unless availablities(status,app).nil?
    end
  end


  def show
    submenu_item 'reports-availability'
    @appid ||= params[:appid]
    @date||= params[:date].nil? ? "last24hours":params[:date]
    @apps=App.all :conditions=>{:tenant_id => current_user.tenant_id}
    select_date(@date)

    app=App.first :conditions=>{:id=>@appid}
    status=app.status1
    s=status.history(:start=>@start,:finish=>@finish)
    sta = {"ok" => 0, "warning" => 0, "critical" => 0, "pending"=>0,"unknown" => 0,}
    s.each do |key, val|
      sta.each do |k,v|
        sta[k] = val[k].to_i + sta[k]
      end
    end

    sta.each {|k,v|
      sta["sum"]||=0
      sta["sum"]+=v.to_f
    }
    sum=sta["sum"]
    sta.each{|k,v|
      sta[k]=sta[k]/sum*100
    }
    app_status=Hash.new()
    app_status[0]=sta["ok"]+sta["warning"]
    app_status[1]=sta["critical"]
    app_status[2]=sta["pending"]
    @app_status = status_object('app',App,app_status)

    @result = Hash.new()
    s.each{|k,v|
      @result[k] ||= Hash.new()
      v.each_value { |val|
        @result[k]["sum"] ||=0
        @result[k]["sum"]+=val.to_f
      }
      sum=@result[k]["sum"]
      v.each { |key,val|
        @result[k][key]=(val.to_f/sum)*100
      }
      @result[k]["ok"]=@result[k]["ok"]+@result[k]["warning"]
      @result[k]["parent_key"]=k
    }
     
    if s.size > 0
      ss=@result.sort
      @stats=Array.new()
      ss.each { |e|
        @stats << e[1].to_hash
      }
      @history_view = status.app_history_view
      @history_view.data = @stats
    end


  end



end
