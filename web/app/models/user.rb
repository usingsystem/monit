require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  has_many :sites, :foreign_key => :tenant_id, :primary_key => :tenant_id
  has_many :apps, :foreign_key => :tenant_id, :primary_key => :tenant_id
  has_many :hosts, :foreign_key => :tenant_id, :primary_key => :tenant_id
  has_many :devices, :foreign_key => :tenant_id, :primary_key => :tenant_id
  has_many :services, :foreign_key => :tenant_id, :primary_key => :tenant_id
  belongs_to :tenant, :include => :operator
  belongs_to :group
  
  has_many :alerts
  has_many :notifications
  has_many :ideas
  has_many :idea_comments
  has_many :idea_votes

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => /\A\w[\w\.\-_]+\z/, :message => "允许字母，数字以及字符.-_"

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message
  validates_length_of       :name,     :maximum => 100
  validates_presence_of     :name

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :mobile,   :with => /^0{0,1}1[0-9]{10}$/
  #validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  validates_each :email do |record, attr, value|
    valid = true
    value.split(",").each do |val|
      valid = false unless val =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    end
    record.errors.add attr, "Email格式有误" unless valid
  end
  validates_presence_of     :old_password, :if => :need_old_password?
  validates_each     :old_password, :if => :need_old_password? do |record, attr, value|

    record.errors.add attr, "错误" if !record.class.authenticate(record.login, value)
  end

#  validates_presence_of  :industry

  after_create :create_rosteruser
  before_create :make_activation_code
  before_save :generate_attr

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :username, :name, :password, :password_confirmation,:work_number,
    :birthday,:company,:department,:job,:phone,:mobile,:description,
    :creator,:state, :old_password,:group_id, :industry, :daily, :weekly, :monthly

  # Return true if the user is the owner of a tenant, otherwise, return false.
  def owner?
    #TODO
  end


  #user preferences
  #preference :host_support_remote, :default => true
  #preference :host_support_snmp, :default => true
  #preference :host_support_ssh, :default => false

  #
  def self.register(attrs)
    new_user = self.create(attrs)
  end

  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end


  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password, operator_id = nil)
    return nil if login.blank? || password.blank?
    #u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u = find :first, :conditions => { :login => login } # need to get the salt
    u = nil if u and operator_id and u.tenant.operator_id != operator_id
    #u && u.authenticated?(password) ? (u.active? ? u : false) : nil
    u && u.authenticated?(password) ? u : nil
  end

  def is_admin?
    self.login == tenant.name
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def create_rosteruser
    Rosteruser.create!({:username => self.username, :jid => "bot@bot.monit.cn", :subscription => "B", :ask => "N", :server => "N", :type => "item"})
  end

  def after_destroy
    Rosteruser.delete_all(["username = ? OR jid = ?", self.username, "#{self.username}@monit.cn"])
  end

  def update_password attrs
    @need_old_password = true
    self.update_attributes(attrs)
  end

  def reset_password attrs
    @reset_password = true
    ok = self.update_attributes(attrs)
    update_attribute(:reset_password_code, nil) if ok
    ok
  end

  def resend_password
    @resend_password = true
    self.reset_password_code = self.class.make_token if self.reset_password_code.blank?
    save
  end

  # Returns true if the user has just been resend_password.
  def recently_resend_password?
    @resend_password 
  end

  #update password need validate password
  def password_required?
    crypted_password.blank? || need_old_password? || @reset_password
  end

  #need old_password when update password
  def need_old_password?
    @need_old_password
  end

  protected

  def generate_attr
    self.username = login
    self.old_password = nil
  end

  def make_activation_code
    #self.activation_code = self.class.make_token
    self.activated_at = Time.now.utc
    self.activation_code = nil
  end

end
