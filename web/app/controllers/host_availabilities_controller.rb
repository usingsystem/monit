class HostAvailabilitiesController < ApplicationController

  before_filter :login_required
  menu_item 'reports'

  def index
    submenu_item 'reports-availability'
    @date||= params[:date].nil? ? "last24hours":params[:date]
    @hosts=Host.all :conditions=>{:tenant_id => current_user.tenant_id}
    select_date(@date)
    @result=[]
    @hosts.each do |host|
     status=host.status1
    @result << availablities(status,host)  unless availablities(status,host).nil?
    end

  end

  def show
    submenu_item 'reports-availability'
    @hostid ||=params[:hostid]
    @date||= params[:date].nil? ? "last24hours":params[:date]
    @hosts=Host.all :conditions=>{:tenant_id => current_user.tenant_id}
    select_date(@date)
    host=Host.first :conditions=>{:id=>@hostid}
    status=host.status1
    s=status.history(:start=>@start,:finish=>@finish)

    sta = {"ok" => 0, "warning" => 0, "critical" => 0, "pending"=>0,"unknown" => 0,}
    s.each do |key, val|
      sta.each do |k,v|
        sta[k] = val[k].to_i + sta[k]
      end
    end
    sta.each { |k,v|
      sta["sum"] ||=0
      sta["sum"]+=v.to_f
    }
    sum=sta["sum"]
    sta.each { |k,v|
      sta[k]=v.to_f/sum
    }
    host_status=Hash.new()
    host_status[0]=sta["ok"]+sta["warning"]
    host_status[1]=sta["critical"]
    host_status[2]=sta["pending"]
    host_status[3]=sta["unknown"]
    @host_status = status_object('host',Host,host_status)
    @result = Hash.new()
    s.each{|k,v|
      @result[k] ||= Hash.new()
      v.each { |key,val|
        @result[k]["sum"] ||=0
        @result[k]["sum"]+=val.to_f
      }
      sum=@result[k]["sum"]
      v.each { |key,val|
        @result[k][key]=(val.to_f/sum)*100
      }
      @result[k]["parent_key"]=k
      @result[k]["ok"]=@result[k]["ok"]+@result[k]["warning"]
    }

    if s.size > 0
      ss=@result.sort
      @stats=Array.new()
      ss.each { |e|
        @stats << e[1].to_hash
      }
       
      @history_view = status.history_view
      @history_view.data = @stats
        
    end

  end


end
