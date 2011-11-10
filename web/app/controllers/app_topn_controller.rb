class AppTopnController < ApplicationController
  # GET /services
  # GET /services.xml
  menu_item 'reports'
  def index
    submenu_item 'reports-top'
    @date||= params[:date].nil? ? "last24hours":params[:date]
    select_date(@date)
    @app_types = AppType.all :conditions => {:level => 2}
    @apptype ||=params[:apptype]

    @apps=App.all :conditions=>{:tenant_id=>current_user.tenant_id,:type_id=>@apptype}

    @apps.each { |app|
      @services=Service.all :conditions=>{:serviceable_type=>2,:serviceable_id=>app.id,:tenant_id => current_user.tenant_id}
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
        @result1[k]=@result
      }
      unless @result1.nil?
        @app_type=Array.new()
        @result1.each { |key,val|
          @result=Hash.new()
          service=Service.first :conditions=>{:uuid=>key}
          if !service.nil? && val.length!=0
            res=Hash.new()
            val.each { |k,v|
              res["sum"] ||=0
              res["total"] ||=0
              res["sum"]+= v["sum"].to_f
              res["total"]+=v["total"].to_f
            }
            @result["avg"]=res["sum"]/res["total"]
            @result["name"]=service.app.name
            @result["type"]=service.type.default_name
          end
          if @result.length>0
            @app_type << @result
          end
        }
        @app_type=@app_type.sort { |x, y|
          y["avg"] <=> x["avg"]
        }
        @app_type=@app_type[0..9]
      end
    }
  end
    
end
