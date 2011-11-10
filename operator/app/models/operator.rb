#encode:utf-8
class Operator < ActiveRecord::Base
  RegistPassword="123456"
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  has_many :tenants,:dependent => :destroy
#             ,
#             :finder_sql=>'SELECT DISTINCT people.* ' +
#             'FROM people p, post_subscriptions ps ' +
#             'WHERE ps.post_id = #{id} AND ps.person_id = p.id ' +
#             'ORDER BY p.first_name'
  has_many :packages
  has_many :orders
  has_many :bills

  validates_presence_of     :host
  validates_length_of       :host,    :within => 3..60
  validates_uniqueness_of   :host

  validates_presence_of     :title
  validates_format_of       :title,    :with => /\A\w[\w\.\-_]+\z/, :message => "允许字母，数字以及字符.-_"
  validates_length_of       :title,     :maximum => 100


  validates_format_of       :telphone,   :with => /^0{0,1}1[0-9]{10}$/, :allow_blank => true

  validates_each :email do |record, attr, value|
    valid = true
    value.split(",").each do |val|
      valid = false unless val =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    end
    record.errors.add attr, "Email格式有误" unless valid
  end

  validates_presence_of :bank,:bank_account_name,:bank_account,:if=>:is_support_bank
  validates_presence_of :alipay_email,:alipay_partner,:alipay_key,:if=>:is_support_alipay
  
  attr_accessor :old_password

  after_create do |r|
    ActiveRecord::Base.connection.execute(
      <<-"end_sql"
INSERT INTO `packages` (`operator_id`,`category`,`name`,`charge`,`year_charge`,`year_discount`,`year_discount_rate`,`max_hosts`,`max_services`,`min_check_interval`,`remark`,`created_at`,`updated_at`,`multi_regional`,`report`,`customer_support`,`data_retention`,`sms_num`,`special_features`)
VALUES
(#{r.id}, 0, '免费版',  0, 0, 0, 0, 1, 6, 600, NULL, NULL, NULL,1, 2, '0', 6, 0, null),
(#{r.id}, 1, '5主机',  49, 588, null, null, 5, 50, 300, NULL, NULL, NULL, 2, 1, '5X8H', 12, 50, null),
(#{r.id}, 1, '10主机', 88, 1056, null, null, 10, 100, 300, NULL, NULL, NULL, 2, 1, '5X8H', 12, 100, null),
(#{r.id}, 1, '20主机', 168, 2016, null, null, 20, 200, 300, NULL, NULL, NULL, 2, 1, '5X8H', 12, 200, null),
(#{r.id}, 2, '10主机', 198, 2376, null, null, 10, 200, 120, NULL, NULL, NULL, 5, 0, '7X24H', 24, 200, '业务视图'),
(#{r.id}, 2, '25主机', 468, 5616, null, null, 25, 500, 120, NULL, NULL, NULL, 5, 0, '7X24H', 24, 500, '业务视图'),
(#{r.id}, 2, '50主机', 858, 10296, null, null, 50, 1000, 120, NULL, NULL, NULL, 5, 0, '7X24H', 24, 1000, '业务视图');
      end_sql
    )
 
  end

  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    #u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u = find :first, :conditions => { :host => login } # need to get the salt
    #u && u.authenticated?(password) ? (u.active? ? u : false) : nil
    u && u.authenticated?(password) ? u : nil
  end

  def update_password(old,new,new_confirmation)
    if old.present?
      if new.present?
        if Operator.authenticate(host,old)
          self.password=new
          self.password_confirmation=new_confirmation
          save
        else
          errors.add("old_password","有误。")
          false
        end
      else
        errors.add("password","不能为空。")
        false
      end
    else
      errors.add("old_password","不能为空。")
      false
    end
  end

  
  private
  def make_activation_code
    #self.activation_code = self.class.make_token
#    self.activated_at = Time.now.utc
#    self.activation_code = nil
  end
end
