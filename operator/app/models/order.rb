class Order < ActiveRecord::Base
  named_scope :order,lambda{|sort|{:order=>"orders.#{sort[:name]} #{sort[:direction]}"} if sort[:name]}
  named_scope :status,lambda{|status|{:conditions=>["orders.status=?",status]} if status}
  named_scope :join_tenant,lambda{|operator|{:joins=>"inner join tenants as te on te.id=tenant_id",:conditions=>["te.operator_id=?",operator.id]}}
  named_scope :out_trade_no_like,lambda{|out_trade_no|{:conditions=>["out_trade_no like ? ","%#{out_trade_no}%"]} if out_trade_no}
  belongs_to :tenant
  belongs_to :package
  validates_inclusion_of :month_num, :in => [1, 3, 6, 12]

  def waiting?
    status == 0
  end

  def pay_success summary = nil
    update_attributes(:is_paid => true, :paid_at => Time.now, :status => 1)
    tenant.add_balance(total_fee, summary)
    tenant.operator.decrement!(:amount, total_fee)    
    Bill.create(:type_id => 1, :balance => tenant.operator.amount, :tenant_id => tenant_id, :operator_id => tenant.operator_id, :amount => -total_fee, :summary => summary) if total_fee > 0
    #验证帐户余额是否够支付套餐
    tenant.handle_package(package_id, month_num) if tenant.balance >= (month_num * package.charge)
  end

  #先生成充值账单
  def pay_from_alipay params
    pay_success "支付宝充值#{body}#{month_num}个月"
    update_attributes(:pay_mode => 1, :alipay_return_params => Rack::Utils.unescape(params.to_param))
  end

  def pay_by_hand
    pay_success "线下支付#{body}#{month_num}个月"
    update_attributes(:pay_mode => 2)
  end

  def pay_mode_name
    pay_mode && self.class.pay_mode[pay_mode] ? self.class.pay_mode[pay_mode] : 'nopay'
  end

  def human_pay_mode_name
    I18n.t("order_pay_mode.#{pay_mode_name}")
  end

  def status_name
    status && self.class.status[status] ? self.class.status[status] : 'waiting'
  end

  def human_status_name
    I18n.t("status.order.#{status_name}")
  end

  def after_create
    operator = tenant.operator
    number = "P#{Time.now.strftime("%y%m%d")}#{id}"
    params = alipay_params({
      "out_trade_no" => number,
      "total_fee" => total_fee,
      "partner" => operator.alipay_partner,
      "seller_email" => operator.alipay_email,
      "notify_url" => "http://#{operator.host}/orders/notify",
      "show_url" => "http://#{operator.host}/orders/#{id}",
      "return_url" => "http://#{operator.host}/orders/return",
      "body" => "#{package.title}套餐付费",
        "subject" => "#{package.title}套餐付费"
    })
    update_attributes({
      :body => params["body"],
      :subject => params["subject"],
      :out_trade_no => number,
      :is_support_alipay => operator.is_support_alipay,
      :is_paid => false,
      :alipay_url => gen_alipay_url(params)
    })
  end

  class << self

    def status
      ['waiting', 'paid','cancel']
    end

    def pay_mode
      ['nopay', 'alipay', 'hand']
    end

  end

  def alipay_params options = {}
    {
      "payment_type" => 1,
      "_input_charset" => "utf-8",
      "service" => "create_direct_pay_by_user",
      "partner" => "",
      "return_url" => "",
      "notify_url" => "",
      "show_url" => "",
      "body" => "",
      "subject" => "",
      "out_trade_no" => "",
      "seller_email" => "",
      "total_fee" => "",
      "sign_type" => "MD5",
      "sign" => ""
    }.update(options)
  end

  def gen_alipay_url _params
    ALIPAY_SERVICE_URL + "?" + _params.update("sign" => sign(_params)).to_param
  end

  def valid_sign(_params)
    !_params["sign"].blank? and _params["sign"] == sign(_params)
  end

  def sign(_params)
    key = tenant.operator.alipay_key
    _params = _params.dup.delete_if{ |k, v| v.blank? or ["sign", "sign_type", "action", "controller", "id", "format"].include?(k) }
    str = _params.to_a.sort{|x, y| x[0].to_s <=> y[0].to_s }.collect{|a| a.join("=")}.join("&")
    str << "#{key}"
    Digest::MD5.hexdigest(str)
  end

end

