class Agent < ActiveRecord::Base

  belongs_to :tenant
  belongs_to :host
  has_many :services, :dependent => :destroy

  validates_presence_of :host_id
  validates_uniqueness_of :host_id
  validates_presence_of :name
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => "不能含有\\/<>&", :allow_nil => true
  validates_length_of       :name,     :maximum => 100
  validates_uniqueness_of :name, :scope => [:tenant_id]


  def human_username
    "#{host.name}<#{username}@agent.monit.cn>"
  end

  def human_presence_name
    I18n.t("status.agent.#{presence}")
  end


  def before_create
    #uuid = Agent.find_by_sql("select uuid() uid from dual")[0].uid
    self.password = newpass(8)
  end

  def newpass( len )
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("1".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def after_create
    title = "agent#{id}.#{tenant.name}"
    update_attributes(:username => title)
    Rosteruser.create!({:username => self.username, :jid => "s@cloud.monit.cn",  :subscription => "B", :ask => "N", :server => "N", :type => "item"})
  end

  def after_destroy
    Rosteruser.delete_all(["username = ? OR jid = ?", self.username, "#{self.username}@agent.monit.cn"])
  end

  protected

  def self.presence
    ['available', 'unavailable', 'busy']
  end

end
