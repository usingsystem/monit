class DeviceTopnController < ApplicationController
  # GET /services
  # GET /services.xml
  menu_item 'reports'
  def index
    submenu_item 'reports-top'
    @date||= params[:date].nil? ? "last24hours":params[:date]
    select_date(@date)
    @service_types=ServiceType.all :conditions=>{:serviceable_type=>4}

    @device_type ||=Hash.new()
    @service_types.each { |type|
      @services=Service.all :conditions=>{:serviceable_type=>4,:tenant_id => current_user.tenant_id,:type_id =>type.id}
      if !@services.nil? && !@date.nil? && @services.size>0
        d=Metric.history(@services,{:start=>@start,:finish=>@finish})
        @result1=Hash.new()
        unless d.nil?
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
              @result[key]= val["sum"].to_f/val["total"].to_f
            }
            @result1[k]=@result
          }
          @device_type[type.default_name]=@result1
        end
      end
    }
    @ping=[]
    @inoctets=[]
    @interface=[]
    @outoctets=[]
    unless @device_type.nil?
      @device_type.each { |k,v|
        if k=="接口-"
          @interface=sub_target(k,v,"usage",@interface)[0..9]
        end
        if k=="接口-"
          @inoctets=sub_target(k,v,"inoctets",@inoctets)[0..9]
        end
        if k=="接口-"
          @outoctets=sub_target(k,v,"outoctets",@outoctets)[0..9]
        end
        if k=="PING监测"
          @ping=sub_target(k,v,'rta',@ping)[0..9]
        end
      }
    end
  end

  def top
    menu_item 'dashboard'
    submenu_item 'top'
    @date||= params[:date].nil? ? "last24hours":params[:date]
    select_date(@date)
    @type ||=params[:type]
    @ping=[]
    @inoctets=[]
    @interface=[]
    @outoctets=[]
    if !@type.nil? && @type=='interface'
      @title="interface"
      dictionary("check_if")
      unless @device_type.nil?
        @device_type.each { |k,v|
          @interface=sub_target(k,v,"usage",@interface)
        }
      end
      @column=["设备","带宽总占用率"]
      @column_text=[]
      @interface.each{ |val|
        text=[]
        text << val["name"]+"/"+val["service"]
        text << format('%.2f',val["usage"])
        @column_text << text
      }
    end
    if !@type.nil? && @type=="inoctets"
      @title="inoctets"
      dictionary("check_if")
      unless @device_type.nil?
        @device_type.each { |k,v|
          @inoctets=sub_target(k,v,"inoctets",@inoctets)
        }
      end
      @column=["主机","接收（Kbps）"]
      @column_text=[]
      @inoctets.each{ |val|
        text=[]
        text << val["name"]+"/"+val["service"]
        text << format('%.2f',val["inoctets"])
        @column_text << text
      }
    end
    if !@type.nil? && @type=="outoctets"
      @title="outoctets"
      dictionary("check_if")
      unless @device_type.nil?
        @device_type.each { |k,v|
          @outoctets=sub_target(k,v,"outoctets",@outoctets)
        }
      end
      @column=["主机","发送（Kbps）"]
      @column_text=[]
      @outoctets.each{ |val|
        text=[]
        text << val["name"]+"/"+val["service"]
        text << format('%.2f',val["outoctets"])
        @column_text << text
      }
    end
    if !@type.nil? && @type=="ping"
      @title="ping"
      dictionary("check_ping")
      unless @device_type.nil?
        @device_type.each { |k,v|
          @ping=sub_target(k,v,'rta',@ping)
        }
      end
      @column=["设备","PING平均时延（ms）"]
      @column_text=[]
      @ping.each{ |val|
        text=[]
        text << val["name"]+"/"+val["service"]
        text << format('%.2f',val["rta"])
        @column_text << text
      }
    end
    
    if (["xls","csv"]).include?(params[:format])
      respond_to do |format|
        format.xls {
          send_data(xls_content_for(@column, @column_text),
            :type => "text/excel;charset=utf-8; header=present",
            :filename => "Report_DeviceTop_#{Time.now.strftime("%Y%m%d")}.xls")
        }
      end
    end
    
  end

  def dictionary(command)
    service_type=ServiceType.first :conditions=>{:serviceable_type=>4,:command=>command}
    @device_type ||=Hash.new()
    @services=Service.all :conditions=>{:serviceable_type=>4,:tenant_id => current_user.tenant_id,:type_id =>service_type.id}
    if !@services.nil? && !@date.nil? && @services.size>0
      d=Metric.history(@services,{:start=>@start,:finish=>@finish})
      @result1=Hash.new()
      unless d.nil?
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
            @result[key]= val["sum"].to_f/val["total"].to_f
          }
          @result1[k]=@result
        }
        @device_type[service_type.default_name]=@result1
      end
    end
  end

  def sub_target(k,v,obj,object)
    v.each{ |key,val|
      @type_result=Hash.new()
      service=Service.first :conditions=>{:uuid=>key}
      if val["#{obj}"]!=nil
        @type_result["#{obj}"]=val["#{obj}"]
        @type_result["name"]=service.device.name
        @type_result["service"]=service.name
        @type_result["type"]=k
        object << @type_result
      end
    }
    object=object.sort { |x, y|
      y["#{obj}"]<=>x["#{obj}"]
    }
    return object
  end


end
