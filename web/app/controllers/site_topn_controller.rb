class SiteTopnController < ApplicationController
  # GET /services
  # GET /services.xml

  menu_item 'reports'

  def index
    submenu_item 'reports-top'
    @date||= params[:date].nil? ? "last24hours":params[:date]
    select_date(@date)
    @service_types=ServiceType.all :conditions=>{:serviceable_type=>3}
    @site_type ||=Hash.new()
    @service_types.each { |type|
      @services=Service.all :conditions=>{:serviceable_type=>3,:tenant_id => current_user.tenant_id,:type_id =>type.id}
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
            @result[key]= val["sum"].to_f/val["total"].to_f
          }
          @result1[k]=@result
        }
        @site_type[type.default_name]=@result1
      end
    }
    @ping=Array.new()
    @dns=[]
    @http=[]
    @site_type.each { |k,v|
      if k=="DNS监测"
        @dns=sub_target(k,v,"time",@dns)
        @dns=@dns[0..9]
      end
      if k=="HTTP监测"
        @http=sub_target(k,v,"time",@http)
        @http=@http[0..9]
      end
      if k=="PING监测"
        @ping=sub_target(k,v,"rta",@ping)
        @ping=@ping[0..9]
      end
    }
  end

  def top
    menu_item 'dashboard'
    submenu_item 'top'
     @date||= params[:date].nil? ? "last24hours":params[:date]
    select_date(@date)
    @type ||=params[:type]
    @ping=Array.new()
    @dns=[]
    @http=[]
    if !@type.nil? && @type=='dns'
      @title="dns"
      command='check_dns'
      dictionary(command)
      @site_type.each { |k,v|
        @dns=sub_target(k,v,"time",@dns)
      }
      @column=["网站","DNS响应时间TopN"]     
      @column_text=[]
      @dns.each{ |val|
        text=[]
        text << val["name"]
        text << format('%.2f',val["time"])
        @column_text << text
      }
    end
    if !@type.nil? && @type=='http'
      @title="http"
      command='check_http'
      dictionary(command)
      @site_type.each { |k,v|
        @http=sub_target(k,v,"time",@http)
      }
      @column=["网站","HTTP时间TopN"]
      @column_text=[]
      @http.each{ |val|
        text=[]
        text << val["name"]
        text << format('%.2f',val["time"])
        @column_text << text
      }
    end
    if !@type.nil? && @type=='ping'
      @title="ping"
      command='check_ping'
      dictionary(command)
      @site_type.each { |k,v|
        @ping=sub_target(k,v,"rta",@ping)
      }
      @column=["网站","PING平均时延"]
      @column_text=[]
      @ping.each{ |val|
        text=[]
        text << val["name"]
        text << format('%.2f',val["rta"])
        @column_text << text
      }
    end

    if (["xls","csv"]).include?(params[:format])
      respond_to do |format|
        format.xls {
          send_data(xls_content_for(@column, @column_text),
            :type => "text/excel;charset=utf-8; header=present",
            :filename => "Report_SiteTop_#{Time.now.strftime("%Y%m%d")}.xls")
        }
      end
    end


  end

  def dictionary(command)
    service_type=ServiceType.first :conditions=>{:serviceable_type=>3,:command=>command}
    @site_type ||=Hash.new()
    @services=Service.all :conditions=>{:serviceable_type=>3,:tenant_id => current_user.tenant_id,:type_id =>service_type.id}
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
          @result[key]= val["sum"].to_f/val["total"].to_f
        }
        @result1[k]=@result
      }
      @site_type[service_type.default_name]=@result1
    end
  end

  def sub_target(k,v,obj,object)
    v.each{ |key,val|
      @type_result=Hash.new()
      service=Service.first :conditions=>{:uuid=>key}
      if val["#{obj}"]!=nil
        @type_result["#{obj}"]=val["#{obj}"]
        @type_result["name"]=service.site.name
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