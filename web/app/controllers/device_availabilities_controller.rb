class DeviceAvailabilitiesController < ApplicationController

  before_filter :login_required
  menu_item 'reports'

  def index
    submenu_item 'reports-availability'
    @date||= params[:date].nil? ? "last24hours":params[:date]
    @devices=Device.all :conditions=>{:tenant_id => current_user.tenant_id}
    select_date(@date)
    @result=[]
    @devices.each do |device|
      status=device.status1
      @result << availablities(status,device) unless availablities(status,device).nil?
    end

  end

  def show
    submenu_item 'reports-availability'
    @deviceid ||=params[:deviceid]
    @date||= params[:date].nil? ? "last24hours":params[:date]
    @devices=Device.all :conditions=>{:tenant_id => current_user.tenant_id}
    select_date(@date)
    device=Device.first :conditions=>{:id=>@deviceid}
    status=device.status1
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
    device_status=Hash.new()
    device_status[0]=sta["ok"]+sta["warning"]
    device_status[1]=sta["critical"]
    device_status[2]=sta["pending"]
    device_status[3]=sta["unknown"]
    @device_status = status_object('device',Device,device_status)

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
       
      @history_view = status.device_history_view
      @history_view.data = @stats
        
    end

  end


end
