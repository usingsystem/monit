class HostTopnController < ApplicationController
  # GET /services
  # GET /services.xml
  menu_item 'reports'
  def index
    submenu_item 'reports-top'
    @date||= params[:date].nil? ? "last24hours":params[:date]
    select_date(@date)
    @service_types=ServiceType.all :conditions=>{:serviceable_type=>1}
    @host_type ||=Hash.new()
    @service_types.each { |type|
      @services=Service.all :conditions=>{:serviceable_type=>1,:tenant_id => current_user.tenant_id,:type_id =>type.id}
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
          @host_type[type.default_name]=@result1
        end
      end
    }
    @ping=[]
    @cpu=[]
    @disk=[]
    @mem=[]
    @swap=[]
    @system=[]
    unless @host_type.nil?
      @host_type.each { |k,v|
        if k=="CPU负载"
          @cpu=sub_target(k,v,"load",@cpu)[0..9]
        end
        if k=="磁盘监测-"
          @disk=sub_target(k,v,"usage",@disk)[0..9]
        end   
        if k=="内存监测"
          @mem=sub_target(k,v,"usage",@mem)[0..9]
        end
        if k=="PING监测"
          @ping=sub_target(k,v,"rta",@ping)[0..9]
        end
        if k=="SWAP监测"
          @swap=sub_target(k,v,"usage",@swap)[0..9]
        end
        if k=="系统负载"
          @system=sub_target(k,v,"load1",@system)[0..9]
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
    @cpu=[]
    @disk=[]
    @mem=[]
    @swap=[]
    @system=[]
    if !@type.nil? && @type=='cpu'
      @title="cpu"
      dictionary("check_cpu_hr")
      unless @host_type.nil?
        @host_type.each { |k,v|
          @cpu=sub_target(k,v,"load",@cpu)
        }
      end
      @column=["主机","一分钟平均负载(%)"]
      @column_text=[]
      @cpu.each{ |val|
        text=[]
        text << val["name"]
        text << format('%.2f',val["load"])
        @column_text << text
      }
    end
    if !@type.nil? && @type=='disk'
      @title="disk"
      dictionary("check_disk_hr")
      unless @host_type.nil?
        @host_type.each { |k,v|
          @disk=sub_target(k,v,"usage",@disk)
        }
      end
      @column=["主机","磁盘占用率(%)"]
      @column_text=[]
      @disk.each{ |val|
        text=[]
        text << val["name"]+"-"+val["service"]
        text << format('%.2f',val["usage"])
        @column_text << text
      }
    end
    if !@type.nil? && @type=='mem'
      @title="mem"
      dictionary("check_mem_free")
      unless @host_type.nil?
        @host_type.each { |k,v|
          @mem=sub_target(k,v,"usage",@mem)
        }
      end
      @column=["主机","内存使用率(%)"]
      @column_text=[]
      @mem.each{ |val|
        text=[]
        text << val["name"]
        text << format('%.2f',val["usage"])
        @column_text << text
      }
    end
    if !@type.nil? && @type=='ping'
      @title="ping"
      dictionary("check_ping")
      unless @host_type.nil?
        @host_type.each { |k,v|
          @ping=sub_target(k,v,"rta",@ping)
        }
      end
      @column=["主机","PING平均时延"]
      @column_text=[]
      @ping.each{ |val|
        text=[]
        text << val["name"]
        text << format('%.2f',val["rta"])
        @column_text << text
      }
    end
    if !@type.nil? && @type=='swap'
      @title="swap"
      dictionary("check_swap_free")
      unless @host_type.nil?
        @host_type.each { |k,v|
          @swap=sub_target(k,v,"usage",@swap)
        }
      end
      @column=["主机","SWAP使用率(%)"]
      @column_text=[]
      @swap.each{ |val|
        text=[]
        text << val["name"]
        text << format('%.2f',val["usage"])
        @column_text << text
      }
    end
    if !@type.nil? && @type=='system'
      @title="system"
      dictionary("check_load_ucd")
      unless @host_type.nil?
        @host_type.each { |k,v|
          @system=sub_target(k,v,"load1",@system)
        }
      end
      @column=["主机","一分钟平均负载(%)"]
      @column_text=[]
      @system.each{ |val|
        text=[]
        text << val["name"]
        text << format('%.2f',val["load1"])
        @column_text << text
      }
    end

    if (["xls","csv"]).include?(params[:format])
      respond_to do |format|
        format.xls {
          send_data(xls_content_for(@column, @column_text),
            :type => "text/excel;charset=utf-8; header=present",
            :filename => "Report_HostTop_#{Time.now.strftime("%Y%m%d")}.xls")
        }
      end
    end

  end

  def dictionary(command)
    service_type=ServiceType.first :conditions=>{:serviceable_type=>1,:command=>command}
    @host_type ||=Hash.new()
    @services=Service.all :conditions=>{:serviceable_type=>1,:tenant_id => current_user.tenant_id,:type_id =>service_type.id}
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
        @host_type[service_type.default_name]=@result1
      end
    end
  end

  def sub_target(k,v,obj,object)
    v.each{ |key,val|
      @type_result=Hash.new()
      service=Service.first :conditions=>{:uuid=>key}
      if val["#{obj}"]!=nil
        @type_result["#{obj}"]=val["#{obj}"]
        @type_result["name"]=service.host.name
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
