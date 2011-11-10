class TrendsController < ApplicationController

  before_filter :login_required
  menu_item 'reports'

  def index
    submenu_item 'reports-trend'
    @object||=params[:object]
    @instance||=params[:instance]
    @serviceid||=params[:serviceid]

    @date||= params[:date].nil? ? "last24hours":params[:date]

    @instances=Trend.area_select(@object,current_user)

    @services=Service.all :conditions=>{:serviceable_type=>@object,:serviceable_id=>@instance,:tenant_id => current_user.tenant_id}

    service=Service.find_by_id(@serviceid)
    unless service.nil?
      @service_name=service.name
      @service = Service.first :conditions=>{:id=>@serviceid,:serviceable_type=>@object,:serviceable_id=>@instance,:tenant_id => current_user.tenant_id,:type_id =>service.type_id}
      if !@service.nil?
        select_date(@date)
        @metric = @service.metric
        d = @metric.history({:start => @start, :finish => @finish})
        if d.size > 0
          @history_views = @metric.history_views
          @history_views.each do |view|
            view.data = d
          end
       
          @data_key=["parent_key"]
          @column=["时间"]
          @history_views.each do |view|
            view.items.each do |v|
              if v.name!="parent_key"
                @data_key << v.name
                if v.data_unit.nil?
                  @column << v.alias
                else
                  @column << v.alias+'('+v.data_unit+')'
                end
              end
            end
          end

          if !@history_views[0].nil?  && @history_views.length>0
            @history_result1=[]
            @history_views[0].data.each do |data1|
              data_result=[]
              @data_key.each do |key|
                data1.each do |d1|
                  if key==d1[0]
                    data_result << d1[1]
                  end
                end
              end
              @history_result1 << data_result
            end
          end

          @result = Hash.new()
          d.each{|m|
            m.each{|k,v|
              metric_type=MetricType.first :conditions=>{:name=>k,:type_id=>service.type_id}
              unless metric_type.nil?
                k=metric_type.desc
              end
              @result[k] ||= Hash.new()
              @result[k]['max'] ||= v.to_f
              @result[k]["min"] ||= v.to_f
              @result[k]["sum"] ||= 0
              @result[k]["total"] ||= 0

              @result[k]["max"] = v.to_f if v.to_f > @result[k]["max"]
              @result[k]["min"] = v.to_f if v.to_f < @result[k]["min"]
              @result[k]["sum"] += v.to_f
              @result[k]["total"] +=1
              @result[k]["last"]=v.to_f
            }
          }
          @result.each{|k, v|
            @result[k]["avg"] = v["sum"]/v["total"]
          }

          if (["xls","csv"]).include?(params[:format])
            respond_to do |format|
              format.xls {
                send_data(xls_content_for(@column,@history_result1),
                  :type => "text/excel;charset=utf-8; header=present",
                  :filename => "Report_Trends_#{Time.now.strftime("%Y%m%d")}.xls")
              }
            end
          end
        end
      end
    end
    
  end

  private

  def xls_content_for(data_key,history_result1)
    xls_report = StringIO.new
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "Trends"

    blue = Spreadsheet::Format.new :color => :blue, :weight => :bold, :size => 10
    sheet1.row(0).default_format = blue

    sheet1.row(0).concat data_key
    count_row = 1
    history_result1.each do |obj|
      j=obj.length-1
      i=0
      for i in 0..j
        if i==0
          sheet1[count_row,i]=Time.at(obj[i].to_i).strftime("%Y-%m-%d %H:%M:%S")
        else
          sheet1[count_row,i]=format('%.2f',obj[i])
        end
      end
      count_row += 1
    end
    book.write xls_report
    xls_report.string
  end

 
end
