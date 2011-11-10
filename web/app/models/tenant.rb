require 'base64'
# 系统业务实体定义：<br>
# (1) 租户：是指一个团体，该团体中可以存在多个。例如：公司. 系统的使用权是出租给某个租户,而不是某个员工或业主。<br>
# (2) 业主: 是指某团体的领导者，该领导者拥有该租户下的所有权限，可以创建租户下的员工。<br>
# (3) 员工: 是指在某团体下工作的员工，他的所有职权来自于业主的分配。
# 业主和员工在系统内部是一样的概念，都属于User 类的实体。
# 因为需要将不同租户的数据分库存储，Tenant 对象除了封装业务相关的属性外，还存储了该租户数据访问的相关信息。
# 例如：数据库地址等信息。
class Tenant < ActiveRecord::Base
  #有效期
  EXPIRED_TIME = 3.days
  before_create :decide_database
  has_many :users
  has_many :sites
  has_many :apps
  has_many :hosts
  has_many :devices
  has_many :services
  has_many :agents
  belongs_to :operator
  belongs_to :package

  def hosts_num
    hosts.count
  end

  def services_num
    services.count
  end

  def is_host_full?
    !is_paid? or self.hosts_num >= package.max_hosts
  end

  def is_service_full?
    !is_paid? or self.services_num >= package.max_services
  end

  #冻结资金,用户套餐付费
  def freeze_balance
    _package = package
    package && package.category !=0 ? ((month_num - current_month) * _package.charge) : 0
  end

  #净资产，除去使用的套餐月数以后所剩余额
  def clean_balance
    _package = package
    package && package.category !=0 ? (balance - (month_num - current_month) * _package.charge) : balance
  end

  def add_balance num, summary = nil
    if num > 0
      #update_attribute(:balance, balance + num)
      increment!(:balance, num)
      Bill.create(:balance => balance, :tenant_id => id, :operator_id => operator_id, :amount => num, :summary => summary) if num > 0
    end
  end

  #本月余额
  def current_month_balance
    is_paid? && package && package.charge.to_i > 0 ? ((package.charge*current_last_days).to_f/current_days).to_f.round(2) : 0
  end

  #本月套餐天数
  def current_days
    next_paid_at ? (next_paid_at - current_paid_at) : 0
  end

  #本月套餐剩余天数
  def current_last_days
    day = next_paid_at ? (next_paid_at - Date.today) : 0
    day > 1 ? (day - 1) : day
  end

  def set_free
    _package = operator.packages.first(:conditions => {:category => 0})
    update_attributes({
      :package_id => _package.id, 
      :begin_at => Date.today, 
      :month_num => 0,
      :end_at => nil,
      :expired_at => nil,
      :current_month => 0,
      :current_paid_at => nil,
      :is_pay_account => false,
      :next_paid_at => nil
    })
  end

  def is_paid?
    (package and package.category == 0) or month_num.to_i > 0
  end

  #预定前，取消当月套餐，结算
  def order_package(package_id)
    last = current_month_balance
    range = "[#{I18n.l(Date.today, :format => :long)} - #{I18n.l(next_paid_at, :format => :long)}]" if next_paid_at
    now = Date.today
    update_attributes({
      :balance => balance + last,
      :package_id => package_id, 
      :begin_at => nil, 
      :month_num => 0,
      :end_at => nil,
      :expired_at => now + EXPIRED_TIME,
      :current_month => 0,
      :current_paid_at => nil,
      :next_paid_at => nil
    })
    Bill.create(:balance => balance, :tenant_id => id, :operator_id => operator_id, :amount => last, :summary => "取消套餐#{package.title}#{range}") if last > 0
    self.package = Package.find(package_id)
  end

  def handle_package(package_id, month_num)
    _package = Package.find(package_id)
    if package
      if package.category == 0 or !is_paid?
        use_package(package_id, month_num)
      elsif package.id == _package.id
        #续费
        add_month_num(month_num)
      else
        #多次预定，不处理
      end
    else
      use_package(package_id, month_num)
    end
  end

  def use_package(package_id, month_num)
    _begin = Date.today
    _end = _begin + month_num.months
    _package = Package.find(package_id)
    cost = _package.charge
    update_attributes({
      :balance => balance - cost,
      :package_id => package_id, 
      :begin_at => _begin, 
      :month_num => month_num,
      :end_at => _end,
      :expired_at => _end + EXPIRED_TIME,
      :current_month => 1,
      :current_paid_at => _begin,
      :is_pay_account => true,
      :next_paid_at => _begin + 1.month
    })
    range = "[#{I18n.l(current_paid_at, :format => :long)} - #{I18n.l(next_paid_at, :format => :long)}]"
    Bill.create(:balance => balance, :tenant_id => id, :operator_id => operator_id, :amount => -cost, :summary => "使用套餐#{_package.title}#{range}") if cost > 0
  end

  #当余额充足时，每月扣费，最后一月结束取消套餐
  def pay_package
    if month_num > current_month
      #续费
      cost = package.charge
      _current_month = current_month + 1
      update_attributes({
        :balance => balance - cost,
        :current_month => _current_month,
        :current_paid_at => next_paid_at,
        :next_paid_at => begin_at + _current_month.month
      })
      range = "[#{I18n.l(current_paid_at, :format => :long)} - #{I18n.l(next_paid_at, :format => :long)}]"
      Bill.create(:balance => balance, :tenant_id => id, :operator_id => operator_id, :amount => -cost, :summary => "使用套餐#{package.title}#{range}") if cost > 0
    else
      #套餐结束，重置
      update_attributes({
        :package_id => nil, 
        :begin_at => nil, 
        :month_num => 0,
        :end_at => nil,
        :current_month => 0,
        :current_paid_at => nil,
        :next_paid_at => nil
      })
    end
  end

  #续费提醒，提前1个礼拜
  def is_need_charge_notice?
    !end_at.blank? and (Date.today + 7.days > end_at)
  end

  #是否过期
  #def is_expired?
  #  !expired_at.blank? and (Date.today > expired_at)
  #end

  def add_month_num(num)
    _num = month_num + num
    _end = begin_at + _num.months
    update_attributes({
      :month_num => _num,
      :end_at => _end,
      :expired_at => _end + EXPIRED_TIME 
    })
  end

  class << self

    def status
      ['normal', 'prepay']
    end

  end

  private
  # 为新创建的租户分配一个数据库存储
  def decide_database
    #TODO 目前不需要分库存储，所有租户都在一个数据库中。
    self.db_host = "127.0.0.1"
    self.db_name = "monit"
    self.port = 3306
    self.username = "root"
    self.password = Base64.encode64("public")#加密存储数据库密码
  end
end
