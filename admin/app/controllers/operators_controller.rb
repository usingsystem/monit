class OperatorsController < ApplicationController
  menu_item 'operators'
  skip_before_filter :login_required, :only=>[:new, :create]# :activate, :resend_password, :reset_password]

  def index
    submenu_item 'operator-index'
    sort=parse_sort params[:sort]
    @operators=Operator.order(sort).paginate(:page=>params[:page])
  end

  def edit
    submenu_item 'operator-index'
    @operator=Operator.find(params[:id])
  end

  def update
    submenu_item 'operator-index'
    @operator=Operator.find(params[:id])
    if @operator.update_attributes(params[:operator])
      flash[:notice] = '修改成功'
      redirect_to :action => 'edit'
    else
      render :action => "edit"
    end
  end
  
  def create
    submenu_item 'operator-index'
    @operator = Operator.new(params[:operator])
    if @operator.save
      flash[:notice]="添加成功！"
      redirect_to operators_path
    else
      render :action => "new"
    end
  end

  def show
    submenu_item 'operator-index'
    @operator=Operator.find(params[:id])
  end

  def new
    submenu_item 'operator-new'
    @operator=Operator.new({
        :footer => "\n  <span id=\"copyright\">Monit © 2010 <a href=\"http://www.miibeian.gov.cn\" target=\"_blank\">备案号</a></span>\n  <span>\n    <a href=\"http://blog.monit.cn\">博客</a>\n    <span class=\"pipe\"> · </span>\n    <a href=\"/about\">关于我们</a>\n    <span class=\"pipe\"> · </span>\n    <a href=\"/contact\">联系我们</a>\n    <span class=\"pipe\"> · </span>\n    <a href=\"/terms\">服务条款</a>\n  </span>\n  ",
        :page_contact => "      <h3>客服</h3>\n      <p>QQ：100009870</p>\n      <p>手机：(+86).18757111178</p>\n      <p>邮箱：service@monit.cn</p>\n      <p>电话：(+86)-0571-89719990-808</p> \n      <p>传真:(+86)-0571-89719991</p>\n      <p>邮编：3100013</p>\n      <p>地址：杭州市万塘路69号华星科技苑C座3层</p>",
        :page_about => "<h3>公司简介</h3>\n      <p>杭州华思通信技术有限公司是一家座落于杭州市高新区的高科技通信软件企业，公司致力于研发和提供新一代颠覆性的基于云计算和SaaS商业模式的融合网络管理产品与服务。\n      </p>\n      <h3>产品服务</h3>\n      <p>公司提供电信综合网管，广电综合网管，企业IT网管，在线托管监控服务等解决方案。公司的WLAN综合网管、EPON综合网管、融合接入网管等产品在国内处于领先地位。\n      </p>\n      <h3>创新技术</h3>\n      <p>我们研发了业界首个基于Erlang技术，按云计算架构研发设计的新一代融合网络管理平台，支持超大规模并发采集、海量数据存储和智能业务分析。领先业界传统网管一代水平。\n      </p>",
        :password=>"888888",
        :password_confirmation=>"888888"
      })
  end

  def confirm
     submenu_item 'operator-index'
    @operator = Operator.find(params[:id])
  end

  def recharge
    submenu_item 'operator-index'
    @operator=Operator.find(params[:id])
    if request.post?
      @bill=@monit.recharge(@operator,params[:bill][:amount].to_f)
      if @bill && !@bill.new_record?
        flash.now[:notice]="充值成功！"
      end
    else
      @bill=@operator.bills.new
    end
  end

end
