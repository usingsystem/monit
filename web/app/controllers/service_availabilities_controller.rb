class ServiceAvailabilitiesController < ApplicationController

  before_filter :login_required
  menu_item 'reports'
  def index
    submenu_item 'reports-availability'
    select_service
    if !@services.nil?
      select_date(@date)
      @result=Hash.new()
      i ||=1
      @services.each do |service|
        status=service.status1
        s=status.history(:start=>@start,:finish=>@finish)

        sta = {"ok" => 0, "warning" => 0, "unknown" => 0, "critical" => 0, "pending"=>0}
        if s.length>0
          s.each do |key, val|
            sta.each do |k,v|
              sta[k] = val[k].to_f + sta[k]
            end
          end

          sta.each{ |k,v|
            sta["sum"] ||=0
            sta["sum"] +=v.to_f
          }
          sum=sta["sum"]
          sta.each{ |k,v|
            sta[k]=v.to_f/sum*100
          }
          sta["name"]=service.name
          sta["id"]=service.id
          @result[i]||={}
          @result[i]=sta
          i=i+1
        end
      end
    end


  end

  def show
    submenu_item 'reports-availability'
    select_service
    service=Service.find_by_id(@serviceid)
    unless service.nil?
      @service = Service.first :conditions=>{:id=>@serviceid,:serviceable_type=>@object,:serviceable_id=>@instance,:tenant_id => current_user.tenant_id,:type_id =>service.type_id}
      if !@service.nil?
        select_date(@date)
        status=@service.status1
        s=status.history(:start=>@start,:finish=>@finish)
        

        sta = {"ok" => 0, "warning" => 0, "critical" => 0, "unknown" => 0,"pending"=>0}
        s.each do |key, val|
          sta.each do |k,v|
            sta[k] = val[k].to_i + sta[k]
          end
        end

        sta.each{ |k,v|
          sta["sum"] ||=0
          sta["sum"] +=v.to_f
        }
        sum=sta["sum"]
        sta.each{ |k,v|
          sta[k]=v.to_f/sum*100
        }

        service_status=Hash.new()
        service_status[0]=sta["ok"]
        service_status[1]=sta["warning"]
        service_status[2]=sta["critical"]
        service_status[3]=sta["unknown"]
        service_status[4]=sta["pending"]
        @service_status = status_object('service',Service,service_status)

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
          @result[k]["parent_key"]=k
        }

        if s.size > 0
          ss=@result.sort
          @stats=Array.new()
          ss.each { |e|
            @stats << e[1].to_hash
          }

          @history_view = status.service_history_view
          @history_view.data = @stats
        end

      end


    end
  end
  


  def select_service
    @object ||= params[:object]
    @instance ||=params[:instance]
    @serviceid ||=params[:serviceid]
    @date||= params[:date].nil? ? "last24hours":params[:date]
    @instances=Trend.area_select(@object,current_user)
    @services=Service.all :conditions=>{:serviceable_type=>@object,:serviceable_id=>@instance,:tenant_id => current_user.tenant_id}
  end


  private
  def status_object name, model, status
    i = -1
    model.status.collect do |x|
      i = i + 1
      {
        :id => i,
        :name => x,
        :color => model.status_colors[i],
        :title => I18n.t("status.#{name}.#{x}"),
        :num => status[i] || 0
      }
    end
  end

end
