class ServiceTopnController < ApplicationController
  # GET /services
  # GET /services.xml
  menu_item 'reports'
  def index
    submenu_item 'reports-top'
    @object ||=params[:object]
    @object ||=1
    @servicetype=params[:servicetype]

    @service_types=ServiceType.all :conditions=>{:serviceable_type=>@object}
    @service_metrics=MetricType.all :conditions=>{:type_id=>@servicetype}
    @date||= params[:date].nil? ? "last24hours":params[:date]
    select_date(@date)

    @services=Service.all :conditions=>{:serviceable_type=>@object,:tenant_id => current_user.tenant_id,:type_id =>@servicetype}
    if !@services.nil? && !@date.nil? && @services.size>0
      d=Metric.history(@services,{:start=>@start,:finish=>@finish})
      @result1=Hash.new()
      d.each { |k,v|
        @result = Hash.new()
        v.each { |key,val|
          val.each{ |key,val|
            @result[key] ||=Hash.new()
            @result[key]["sum"] ||=0
            @result[key]["total"] ||=0
            @result[key]["sum"]+=val.to_f
            @result[key]["total"]+=1
          }               
        }
        @result.each{|key,val|
          @result[key]["avg"] = val["sum"].to_f/val["total"].to_f
        }
        @result1[k]=@result
      }

      @metric_id ||=params[:metric_id]
      @metric=MetricType.first :conditions=>{:id=>@metric_id,:type_id=>@servicetype}
      unless @metric.nil?
        @servicemetric=@metric.name
        if @result1.length!=0
          @instance_type=Array.new()
          @result1.each { |key,val|
            @result=Hash.new()
            val.each{|k,v|
              if k==@servicemetric && v["avg"]!=nil
                @result["avg"]=v["avg"]
              end
            }
            if @result["avg"]!=nil
              service=Service.first :conditions=>{:uuid=>key,:tenant_id=>current_user.tenant_id,:type_id =>@servicetype}
              unless service.nil?
                serviceable_type=service.serviceable_type
                serviceable_id=service.serviceable_id
                if serviceable_type==1
                  instance=Host.first :conditions=>{:id=>serviceable_id,:tenant_id=>current_user.tenant_id}
                end
                if serviceable_type==2
                  instance=App.first :conditions=>{:id=>serviceable_id,:tenant_id=>current_user.tenant_id}
                end
                if serviceable_type==3
                  instance=Site.first :conditions=>{:id=>serviceable_id,:tenant_id=>current_user.tenant_id}
                end
                if serviceable_type==4
                  instance=Device.first :conditions=>{:id=>serviceable_id,:tenant_id=>current_user.tenant_id}
                end
                @result["name"]=instance.name+"/"+service.name
                @result["id"]=service.id
              end
              @instance_type << @result
            end
         
          }

          if @instance_type && @instance_type.length>0
            @instance_type = @instance_type.sort{|x,y|
              y["avg"]<=>x["avg"]
            }
             @instance_type=@instance_type[0..9]
            service_view=View.new({:template=>"amcolumn",:enable=>1,:dimensionality=>3,:width=>"100%",:height=>"400"})
            instance={@metric.desc => @metric.desc}
            service_view.items<< ViewItem.new(:name=> @metric.desc ,:alias=> @metric.desc, :data_type => "string")
            @instance_type.each{ |s|
                instance["#{s["id"]}"]=s["avg"]
                service_view.items<< ViewItem.new(:name=>"#{s["id"]}",:alias=>s["name"], :data_type => "float")
            }
            @service_view=service_view           
            @service_view.data=[instance]
          end
        end
      end
    end

    

   
    
  end
end
